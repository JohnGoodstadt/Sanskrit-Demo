//
//  GroupAudioViewController.swift
//  SanskritDemo
//
//  Created by John goodstadt on 12/02/2023.
//

import UIKit
import AVFoundation

class UIDAudio{
	var UID:String
	var audio:Data
	var title:String
	
	init(UID:String,audio:Data,title:String){
		self.UID = UID
		self.audio = audio
		self.title = title
	}
	
}

class AudioListViewController: UIViewController {
	
	public var group:RecallGroup!
	
	@IBOutlet weak var playButton: UIBarButtonItem!
	@IBOutlet weak var tableview: UITableView!
	
	private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
	private var playlistQ = Queue<UIDAudio>()
	private var lastPlayedUID = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableview.dataSource = self
		tableview.delegate = self
		tableview.reloadData()
		
	}
	override func viewDidDisappear(_ animated: Bool) {
		
		if audioPlayer.isPlaying {
			audioPlayer.stop()
		}

		super.viewDidDisappear(animated)
	}
	@IBAction func playButtonPresssed(_ sender: Any) {
		
		startOrStopPlayingOfPlaylist()

	}
	
	func startOrStopPlayingOfPlaylist(){
		
		
		guard !audioPlayer.isPlaying else {
			audioPlayer.stop()
			colorIconNotPlaying()
			return
		}
		

		if isPlaylistEmpty() {
			createPlaylist()
			
			fillPlaylistFromList()
		} //else start from where we left off
		
#if DEBUG
		debugQueue("playlist filled")
#endif
		
		
		if isPlaylistEmpty() {
			colorIconNotPlaying()
		}else{ //play more
			if (playNextTrack() ){ //something has played
				colorIconPlaying()
			}else{
				colorIconNotPlaying() //last item has played
			}
		}
		
	}
	fileprivate func fillPlaylistFromList() {
		
		group.itemList.forEach{
			addAudio($0.UID,$0.audio,$0.title)
		}
		
	}
	private func colorIconNotPlaying(){
		
		if let navbutton = playButton {
			navbutton.tintColor = UIColor.systemBlue
		}
		
	}
	private func colorIconPlaying(){
		
		if let navbutton = playButton {
			navbutton.tintColor = UIColor.systemRed
		}
		
	}
}
extension AudioListViewController: UITableViewDataSource, UITableViewDelegate {
	
	//MARK: - Tableview Datasource Function
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return self.group.itemList.count
		
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return 1
		
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let item = group.itemList[indexPath.row]
		
		let customCell = tableView.dequeueReusableCell(withIdentifier: "learningWithSubtitleCellID") as! LearningWithSubtitleTableViewCell
		let titleForLine = item.title
		
		customCell.titleLabel.text = titleForLine
		customCell.subtitleLabel.text = item.subtitle
		
		
		customCell.photoImageView.setImageForApp(thumbnail: item.thumbnail,title:item.title)
		
		
		setSelectedBackgroungView(customCell)
		return customCell
		
		
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let item = group.itemList[indexPath.row]
		
		let vc = ListenViewController(item: item)
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
		self.navigationController?.pushViewController(vc, animated: true)
		
		
	}
	//MARK:- Tableview Delegate Function
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
		
		var returnValue = CGFloat(40.0)
		if (UIDevice.current.userInterfaceIdiom == .pad) {
			returnValue = CGFloat(50.0)
		}
		
		return returnValue
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.group.title
	}
	fileprivate func setSelectedBackgroungView(_ customCell: UITableViewCell) {
		let bgColorView = UIView()
		bgColorView.backgroundColor = HILIGHT_CELL_COLOR
		bgColorView.layer.masksToBounds = true
		customCell.selectedBackgroundView = bgColorView
	}
}
extension AudioListViewController: AVAudioPlayerDelegate {
	public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
		
		///we have a valid mp3 to play
		if isPlaylistNotEmpty()  {
			if !isNextAudioPlayable() {
				colorIconNotPlaying()
			}else{
				playNextTrack()
			}
		}else{
			colorIconNotPlaying()
		}
	}
}
//MARK: - Play List functions
extension AudioListViewController {
	
	func stop(){
		
		if self.audioPlayer.isPlaying {
			self.audioPlayer.stop()
		}
	}
	func isPlaying() -> Bool {
		
		return self.audioPlayer.isPlaying
	}
	func isNotPlaying() -> Bool {
		
		return !isPlaying()
	}
//MARK: - playlist properties
	func createPlaylist(){
		playlistQ.clear()
	}
	func isPlaylistEmpty() -> Bool{
		return playlistQ.getElements.isEmpty
	}
	func isPlaylistNotEmpty() -> Bool{
		return !isPlaylistEmpty()
	}
	func getPlayListCount() -> Int {
		return playlistQ.getElements.count
	}
	
	func addAudio(_ UID:String,_ audio:Data,_ title:String = ""){
		let entry = UIDAudio(UID: UID,audio: audio, title: title)
		playlistQ.enqueue(entry)
	}
	
	func isNextAudioPlayable() -> Bool{
		if playlistQ.peek?.audio.count ?? 0 > MINIMUM_AUDIO_SIZE {
			return true
		}else{
			return false
		}
	}
	func isNextAudioUnplayable() -> Bool{
		return !isNextAudioPlayable()
	}
	func readNextAudioUID() -> String {
		return playlistQ.peek?.UID ?? ""
	}
	func currentTime() ->  Float {
		return Float(audioPlayer.currentTime)
	}
	static func mp3duration(_ audio:Data) ->  Float {
		
		do{
			let player = try AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			player.prepareToPlay()
			return Float(player.duration )
		}catch{
			return 1.0
		}
		
	}
	func getNextTrack() -> Data{
		let item = playlistQ.dequeue() //FIFO - guaranteed valid mp3
		return item?.audio ?? Data()
	}
	
	func getEmptyElements() -> [UIDAudio] {
		return playlistQ.getElements.filter { $0.audio.count < MINIMUM_AUDIO_SIZE }
	}
	//	func getEmptyElements() -> [UIDAudio] {
	//		return playlistQ.getElements.filter { $0.audio.count < MINIMUM_AUDIO_SIZE }
	//	}
	func getEmptyElementsCount() -> Int {
		return playlistQ.getElements.filter { $0.audio.count < MINIMUM_AUDIO_SIZE }.count
	}
	
	func getNextMissingAudios(_ howmany:Int) -> [String] {
		
		let missing = getEmptyElements()
		
		return Array( missing.map { $0.UID }.prefix(howmany) )
		
	}
	func assignAudio(_ UID:String,_ audio:Data) {
		let items = playlistQ.getElements.filter { $0.UID == UID}
		if items.isNotEmpty{
			if let item = items.first {
				item.audio = audio
				print("assigning \(item)")
			}
		}
		
	}
	func debugAudio(_ UID:String){
		
		let items = playlistQ.getElements.filter { $0.UID == UID}
		if items.isNotEmpty{
			if let item = items.first {
				print(" \(item.audio.count) \(item.title) \(item.UID.prefix(4))")
			}
		}
	}
	func  playMp3(_ audio:Data){
		
		guard audio.count > MINIMUM_AUDIO_SIZE else{
			return
		}
		
		do{
			audioPlayer = try AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			self.audioPlayer.delegate = self
			self.audioPlayer.prepareToPlay()
			self.audioPlayer.play()
			
		}catch{
			print(error)
		}
		
	}


	func playNextTrackNow(){
		
		if let item = playlistQ.dequeue() { //FIFO - guaranteed valid mp3
			
			guard item.audio.count > MINIMUM_AUDIO_SIZE else{
				return
			}
			
			do{
				self.lastPlayedUID = item.UID //for audioPlayerDidFinishPlaying()
				self.audioPlayer = try AVAudioPlayer(data: item.audio , fileTypeHint: "mp3")
				self.audioPlayer.delegate = self
				self.audioPlayer.play()
			}catch{
				print(error)
			}
		}
		
		
	}
	
	@discardableResult
	private func playNextTrack() -> Bool {
	
		if isPlaylistEmpty() { return false }
			
		guard isNextAudioPlayable() else {
			return false
		}
			
		playNextTrackNow()

		return true
	}
	func debugQueue(_ message:String){
		
		print(message)
		
		for track in self.playlistQ.getElements.enumerated() {
			if track.element.title.isNotEmpty {
				print(" \(track.element.audio.count) \(track.element.title) \(track.element.UID.prefix(4))")
			}else{
				print(" \(track.element.audio.count) \(track.element.UID.prefix(8))")
			}
		}
		
	}
}
