//
//  LinkedGroupsViewController.swift
//  SanskritDemo
//
//  Created by John goodstadt on 12/02/2023.
//

import UIKit

class GroupsViewController: UIViewController {
	
	@IBOutlet weak var tableview: UITableView!
	@objc var recallGroup:RecallGroup!
	var childGroups = [RecallGroup]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		guard self.recallGroup.hasChild else {
			print("Agh no children")
			return
		}
		
		setupTableData()
		
		self.title = self.recallGroup?.title
	}
	fileprivate func setupTableData() {
		
		childGroups.removeAll(keepingCapacity: true)
		
		let childrenUnsorted = Current.groups.filter { $0.hasParent }
		let children = sortGroupByTitleOnly(childrenUnsorted)
		
		for child in children{
			for UID in recallGroup.groupUIDList {
				if  UID == child.UID {
					childGroups.append(child)
				}
			}
		}
	}
}
extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		
		return  childGroups.count
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		
		return childGroups[section].title
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "LinkedGroupTableViewCellID", for: indexPath) as! LinkedGroupTableViewCell
		
		let rg = self.childGroups[indexPath.section]
		
		cell.titleLabel.text = chooseGroupTitle(rg)
		cell.summaryTitleLabel.text = ""
		cell.label1.text = ""
		cell.label2.text = ""
		cell.label3.text = ""
		
		
		cell.photoImageView.setImageForApp(group: rg)
		
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let group = self.childGroups[indexPath.section]
		
		if group.hasChild {
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
}
