//
//  ViewController.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
	
	@IBOutlet weak var imageImageView: UIImageView!
	private var audioPlayer: AVAudioPlayer?
	private var parentGroups:[RecallGroup] = [RecallGroup]()
	
	@IBOutlet weak var tableview: UITableView!
	
	let textCellIdentifier = "TableViewCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		filterParentGroups()
		
		tableview.dataSource = self
		tableview.delegate = self
		tableview.reloadData()
	}


	@IBAction func SettingsButtonPressed(_ sender: Any) {
		
		//1.
		let jsonfile = getDocumentsDirectoryString().appending("/sanskritImages.json")
		
		do{
			
			let jsondata = try  Data(contentsOf: URL(fileURLWithPath: jsonfile))
			print(jsondata.prefix(64))
			
			let images = try JSONDecoder().decode([ImageDocument].self, from: jsondata)
			
			print(images.count)
			
			if !images.isEmpty {
				imageImageView.image = UIImage(data: images[0].image)
			}
			
		}catch{
			print(error)
		}
		
		//2.
		let jsonAudio = getDocumentsDirectoryString().appending("/sanskritAudio.json")
		
		do{
			
			let jsondata = try  Data(contentsOf: URL(fileURLWithPath: jsonAudio))
			print(jsonAudio.prefix(64))
			
			let audioDoc = try JSONDecoder().decode([AudioDocument].self, from: jsondata)
			
			print(audioDoc.count)
			
			if !audioDoc.isEmpty {
				audioPlayer = try AVAudioPlayer(data: audioDoc[0].audio , fileTypeHint: "mp3")
				audioPlayer?.play()
			}
			
			
			
		}catch{
			print(error)
		}
		
		//3.
		let jsonGroups = getDocumentsDirectoryString().appending("/sanskritGroups.json")
		
		do{
			
			let jsondata = try  Data(contentsOf: URL(fileURLWithPath: jsonGroups))
			print(jsondata.prefix(64))
			
			let groups = try JSONDecoder().decode([RecallGroup].self, from: jsondata)
			
			print(groups.count)
			
			print("<===== Groups =====>")
			groups.prefix(10).forEach{
				print($0.title)
			}
		}catch{
			print(error)
		}
		
		//4.
		let jsonItems = getDocumentsDirectoryString().appending("/sanskritItems.json")
		
		do{
			
			let jsondata = try  Data(contentsOf: URL(fileURLWithPath: jsonItems))
			print(jsondata.prefix(64))
			
			let items = try JSONDecoder().decode([RecallGroup].self, from: jsondata)
			
			print(items.count)
			
			print("<===== items =====>")
			items.prefix(10).forEach{
				print($0.title)
			}
		}catch{
			print(error)
		}
	}
	func filterParentGroups(){
		let filteredGroups = Current.groups.filter { $0.hasParent == false }
		self.parentGroups = sortGroupByTitleOnly(filteredGroups)
		
	}
}


extension ViewController: UITableViewDelegate {
	
}
extension ViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.parentGroups.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "groupSummaryCellID") as! GroupSummaryTableViewCell
		
		let group = self.parentGroups[indexPath.section]
		
		cell.titleLabel.text = chooseGroupTitle(group)
		cell.summaryTitleLabel.text = groupSummaryTitle(group)
		cell.label1.text = ""
		cell.label2.text = ""
		cell.label3.text = ""
		
		cell.photoImageView.setImageForApp(group: group)

		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let group = self.parentGroups[indexPath.section]
		
		navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
		if  group.hasChild {
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "LinkedSummaryViewControllerSID") as! GroupsViewController
			vc.recallGroup = group
			navigationController?.pushViewController(vc, animated: true)
		}else{
			let storyboard = UIStoryboard(name: "GroupAudio", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "GroupAudioViewControllerSBID") as! AudioListViewController
			vc.group = group
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.parentGroups[section].title
	}
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
}
