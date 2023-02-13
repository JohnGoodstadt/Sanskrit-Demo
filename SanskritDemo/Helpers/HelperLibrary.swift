//
//  HelperLibrary.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import Foundation
import UIKit

public func getDocumentsDirectoryString() -> String {
	let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
	let documentsDirectory = paths[0]
	return documentsDirectory
}

public enum origin_enum : Int, CustomStringConvertible,Codable, CaseIterable{
	
	case sample = 0   	// item originated from a sample
	case user			// item originated from a user input
	case transfer		// item transferred in from someone else
	
	public var description : String {
		switch self {
			case .sample: return "Sample"
			case .user: return "User"
			case .transfer: return "transfer"
		}
	}
}
//MARK: - Inital Data
public func readData() {
	
	if let url = Bundle.main.path(forResource: "sanskritGroups", ofType: "json") {
		
		if !url.isEmpty {
			do{
				let data = try  Data(contentsOf: URL(fileURLWithPath: url))
				Current.groups = try JSONDecoder().decode([RecallGroup].self, from: data)
			}catch {
				print(error)
				print("===========================================")
				print("====>ERROR READING CACHED GROUPS JSON <====")
				print("===========================================")
				fatalError("ERROR READING CACHED GROUPS JSON ")
			}
		}
	}
	
	if let url = Bundle.main.path(forResource: "sanskritItems", ofType: "json") {
		
		if !url.isEmpty {
			do{
				let data = try  Data(contentsOf: URL(fileURLWithPath: url))
				Current.items = try JSONDecoder().decode([RecallItem].self, from: data)
			}catch {
				print(error)
				print("==========================================")
				print("====>ERROR READING CACHED ITEMS JSON <====")
				print("==========================================")
				fatalError("ERROR READING CACHED ITEMS JSON ")
			}
		}
	}
	
	
	joinItemsAndGroups(Current.items,Current.groups)
	
	//MARK: - Grab Image and audio Data
	//if already saved dont copy and extract - just use


	
	if fileExists(IMAGES_FILE_NAME_JSON) {
			var url = URL(fileURLWithPath: getDocumentsDirectoryString())
			url.appendPathComponent(IMAGES_FILE_NAME_JSON)
			
			decodeImages(url)
	}else{
		//copy from bundle to docs
		if let url = Bundle.main.path(forResource: IMAGES_FILE_NAME_ZIP, ofType: nil) {
			let zipPath = copyFileURLToDocuments(url,IMAGES_FILE_NAME_ZIP)
			let url = UNZIP(from: URL(fileURLWithPath: zipPath),filename:IMAGES_FILE_NAME_JSON)

			decodeImages(url)
		}
	}

	
	if fileExists(AUDIO_FILE_NAME_JSON) {
		var url = URL(fileURLWithPath: getDocumentsDirectoryString())
		url.appendPathComponent(AUDIO_FILE_NAME_JSON)
		
		decodeAudio(url)
	}else{
		//copy from bundle to docs
		if let url = Bundle.main.path(forResource: AUDIO_FILE_NAME_ZIP, ofType: nil) {
			let zipPath = copyFileURLToDocuments(url,AUDIO_FILE_NAME_ZIP)
			let url = UNZIP(from: URL(fileURLWithPath: zipPath),filename:AUDIO_FILE_NAME_JSON)

			decodeAudio(url)
		}
	}

}

fileprivate func decodeImages(_ url:URL){
	do{
		let data = try  Data(contentsOf:  url.appendingPathComponent(IMAGES_FILE_NAME_JSON))
	
		let imageDocs = try JSONDecoder().decode([ImageDocument].self, from: data)
		addImages(Current.items,images: imageDocs)
		
	}catch {
		print(error)
		print("===========================================")
		print("====>ERROR READING CACHED IMAGES JSON <====")
		print("===========================================")
		fatalError("ERROR READING CACHED IMAGES JSON ")
	}
}

fileprivate func decodeAudio(_ url:URL){
	do{
		let data = try  Data(contentsOf:  url.appendingPathComponent(AUDIO_FILE_NAME_JSON))
		let audioDocuments = try JSONDecoder().decode([AudioDocument].self, from: data)
		addAudio(Current.items, audioDocs: audioDocuments)
	}catch {
		print(error)
		print("===========================================")
		print("====>ERROR READING CACHED AUDIO JSON <====")
		print("===========================================")

	}
}
///
/// Make all groups point to related item list
///
fileprivate func joinItemsAndGroups(_ items: [ RecallItem], _ groups: [RecallGroup]) {
	
	
	guard items.isEmpty == false && groups.isEmpty == false else{
		return
	}
	
	//1. make lookup dict for performance
	//2. for each item lookup group and assign
	
	print("\(Date()) read groups: \(groups.count) rows, items: \(items.count) rows")
	
	let lookupDict = groups.toDictionary { $0.UID } //peformance lookup
	
	
	//A points to B and B has a list of A's
	for item in items {
		if item.busDepotUID.isNotEmpty {
			
			let key = item.busDepotUID
			
			if let group = lookupDict[key] {
				item.recallGroup = group
				group.addItem(item)
			}
		}
	}
}
fileprivate func addImages(_ items: [RecallItem], images:[ImageDocument]) {
	
	
	guard items.isEmpty == false else{
		return
	}
	
	//1. make lookup dict for performance
	//2. for each item lookup and assign
	
	let lookupDict = images.toDictionary { $0.UID } //peformance lookup
	
	for item in items {
		
		let key = item.UID
		
		if let imageDoc = lookupDict[key] {
			item.prompt = imageDoc.image
			item.hasPrompt = true
			
			if let thumbnailImage =  UIImage(data: imageDoc.image) {
				if let thumbnail = thumbnailImage.scale(with: CGFloat(IMAGE_THUMBNAIL_SMALL)) {
					if let jpg = thumbnail.jpegData(compressionQuality: 0.0){
						item.thumbnail = jpg
					}
				}
			}
		}
	}
}
fileprivate func addAudio(_ items: [RecallItem], audioDocs:[AudioDocument]) {
	
	
	guard items.isEmpty == false else{
		return
	}
	
	//1. make lookup dict for performance
	//2. for each item lookup assign
	
	let lookupDict = audioDocs.toDictionary { $0.UID } //peformance lookup
	
	for item in items {
		let key = item.UID
		
		if let audioDoc = lookupDict[key] {
			item.audio = audioDoc.audio
		}
	}
}
//MARK: - Sort
public func sortByDiacriticTitleOnly(_ items:[RecallItem]) -> [RecallItem]{
	
	let sortedItems = items.sorted(by: { (lhs: RecallItem, rhs: RecallItem) -> Bool in
		return  lhs.title.forNonDiatricicSorting < rhs.title.forNonDiatricicSorting
	})
	
	
	return sortedItems
}
public func sortGroupsByDiacriticTitleOnly(_ groups:[RecallGroup]) -> [RecallGroup]{
	
	let sortedItems = groups.sorted(by: { (lhs: RecallGroup, rhs: RecallGroup) -> Bool in
		return  lhs.title.forNonDiatricicSorting < rhs.title.forNonDiatricicSorting
	})
	
	
	return sortedItems
}
public func sortGroupByTitleOnly(_ items:[RecallGroup]) -> [RecallGroup]{
	
	let sortedItems = items.sorted(by: { (lhs: RecallGroup, rhs: RecallGroup) -> Bool in
		return lhs.title.localizedCompare(rhs.title.forNonDiatricicSorting ) == .orderedAscending
	})
	
	return sortedItems
	
}
public func sortByTitleOnly(_ items:[RecallItem]) -> [RecallItem]{
	
	let sortedItems = items.sorted(by: { (lhs: RecallItem, rhs: RecallItem) -> Bool in
		return lhs.title.localizedCompare(rhs.title) == .orderedAscending
	})
	
	return sortedItems
}
public func sortBySortOrderOnly(_ items:[RecallItem]) -> [RecallItem]{
	
	let sortedItems = items.sorted(by: { (lhs: RecallItem, rhs: RecallItem) -> Bool in
		return  lhs.sortorder < rhs.sortorder //asc
	})
	
	return sortedItems
}
//MARK: - Group
public func chooseGroupTitle(_ group:RecallGroup) -> String {
	
	var returnValue = "default title"//groupTitleDefault".branded
	
	let recallItems = group.itemList
	
	
	if group.hasChild { //linked group
		if group.groupUIDList.count > 0 {
			if group.groupUIDList.count == 1 {
				returnValue = "1 group"
			}else{
				returnValue = "\(group.groupUIDList.count) groups" //as sub group could be mixed type just say groups
			}
		}else{
			returnValue = "No items or groups"
		}
	}else{
		
		
		guard let _ = recallItems.first else {
			return returnValue
		}
		
		if recallItems.isNotEmpty {
			
			
			if( recallItems.count == 1 ){
				returnValue = "1 Asana"
			}else{
				returnValue = "\(recallItems.count) Asanas"
			}
			
		}
		
#if DONT_COMPILE
		//normal group
		if recallItems.isNotEmpty() {
			
			
			if( recallItems.count == 1 ){
				returnValue = "1 \(rg.contentTypeString(singular: true))"
			}else{
				returnValue = "\(recallItems.count) \(rg.contentTypeString())"
			}
			
		}
#endif
	}
	
	
	
	return returnValue
	
}
public func groupSummaryTitle(_ group:RecallGroup) -> String {
	var returnValue = "active"
	
	if group.hasChild { //group of groups - linked group
		if group.groupUIDList.count > 0 {
			let howManySubItems = findChildrenCount(group.groupUIDList)
			if howManySubItems <= 1 {
				returnValue = howManySubItems == 0 ? "No Asanas" : "1 Asana"
			}else {
				returnValue = "\(howManySubItems) Asanas"
			}
		}else{
			returnValue = "Not active"
		}
	}else{
		
	}
	
	return returnValue
}
//MARK: - Children
public func findChildrenCount(_ groupUIDs:[String]) -> Int {
	
	var returnValue = 0
	
	//1. look at all groups with children
	//2. then find in groupList
	//3. add up itemså
	
	let children = Current.groups.filter {NSPredicate(format: "hasParent == %@", NSNumber(value: true)).evaluate(with: $0) }
	
	
	for rg in children {
		
		for UID in groupUIDs {
			if UID == rg.UID {
				returnValue = returnValue + rg.itemList.count
			}
		}
		
	}
	return returnValue
	
}


public func findChildImage(group:RecallGroup) -> Data? {
	
	guard group.hasChild && group.groupUIDList.isNotEmpty else {
		return Data()
	}
	
	for groupUID in group.groupUIDList {
		if let childGroup = findChild(groupUID) {
			for item in childGroup.itemList {
				if item.thumbnail.isNotEmpty {
					return item.thumbnail //only positive exit
				}
			}
		}
	}
	
	
	return Data()
	
}
fileprivate func findChild(_ lookingForGroupUID:String) -> RecallGroup? {
	
	let returnValue:RecallGroup? = nil//[RecallGroup]() //guarenteed 1 item or nil (should not happen)
	
	//1. look at all groups with children
	//2. then find in groupList
	
	let children = Current.groups.filter {NSPredicate(format: "hasParent == %@", NSNumber(value: true)).evaluate(with: $0) }
	
	
	for group in children {
		if lookingForGroupUID == group.UID {
			return group //only matched exit
		}
	}
	return returnValue //should not happen
	
}
