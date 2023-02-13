//
//  ListenInteractor.swift
//  SanskritDemo
//
//  Created by John goodstadt on 13/02/2023.
//

import Foundation
import AVFoundation
/*
 https://levelup.gitconnected.com/add-custom-xcode-templates-bec9c3099766
 */
protocol IListenInteractor {
	func loadData(item:RecallItem)
	func playMP3(item:RecallItem)
	func playOrPause(_ item:RecallItem)
	func trackDuration(audio:Data)
	func endAudio()
}

final class ListenInteractor: NSObject {
    
    // MARK: - Properties
    //private
	var presenter: ListenPresenter?
    //private
	var worker: ListenWorker?
    
	private var audioPlayer: AVAudioPlayer = AVAudioPlayer()
	private var audioTimer = Timer() //for updating slider
}

extension ListenInteractor: IListenInteractor {
	func playOrPause(_ item:RecallItem) {
		
		if self.audioPlayer.isPlaying {
			endAudio()
		}else{
			playMP3(item: item)
		}
	}
	
	func trackDuration(audio: Data) {
		
		let duration = mp3duration(audio)
		presenter?.trackDuration(duration)
	}
	
	func endAudio() {
		self.audioTimer.invalidate()
		self.audioPlayer.stop()
	}
	
	
	func loadData(item:RecallItem){
		let response = ListenDisplay.LoadData.Response(item: item)
		presenter?.presentDetails(response: response)
	}
	func playMP3(item:RecallItem){
		guard item.audio.isNotEmpty else {
			print("Error: audio is empty. Cannot play mp3")
			return
		}
		
		self.audioTimer.invalidate()
		self.audioTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.currentPlayTime), userInfo: nil, repeats: true)

		presenter?.presentPlayingState(true)
		do{
			audioPlayer = try AVAudioPlayer(data: item.audio , fileTypeHint: "mp3")
			audioPlayer.delegate = self
			audioPlayer.prepareToPlay()
			audioPlayer.play()
			
		}catch{
			print(error)
		}
	}
	@objc func currentPlayTime(_ timer: Timer) {
		
		presenter?.presentPlayTime(Float(audioPlayer.currentTime))

	}
	func mp3duration(_ audio:Data) ->  Float {
		
		do{
			let player = try AVAudioPlayer(data: audio , fileTypeHint: "mp3")
			player.prepareToPlay()
			return Float(player.duration )
		}catch{
			return 1.0
		}
	}
}
extension ListenInteractor: AVAudioPlayerDelegate {
	
	@objc public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
		presenter?.presentPlayingState(false)
	}
}
