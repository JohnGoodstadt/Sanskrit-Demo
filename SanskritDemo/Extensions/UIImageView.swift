//
//  UIImage.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import UIKit

extension UIImageView {
	
	public func setImageForApp(group:RecallGroup){
		
		//defult circle
		self.backgroundColor = UIColor.clear;
		self.layer.cornerRadius =  self.frame.size.height / 2;
		self.layer.masksToBounds = true;
		
		//1.
		if group.thumbnail.count > 1 {
			self.image = UIImage(data: group.thumbnail)
			self.layer.borderWidth = 0
			return
		}
		
		//1a
		if group.pinnedItemUID.isNotEmpty &&  group.itemList.isNotEmpty {
			
			if let pinnedItem = group.itemList.filter({ $0.UID == group.pinnedItemUID}).first {
				if pinnedItem.thumbnail.isNotEmpty{
					self.image =  UIImage(data: pinnedItem.thumbnail)
					self.layer.borderWidth = 0
					print("image case 1a. pinned item \(group.title)")
					return
				} //otherwise keep going
			}
		}
		
		//2.
		if group.itemList.isNotEmpty {
			var items = group.itemList
			if group.sortitems == .alpha {
				items = sortByTitleOnly(items)
			}else{ //my sort - custom
				items = sortBySortOrderOnly(items)
			}
			
			let top5 = items.prefix(5) //assume we will have an image in at least some
			var foundImage = Data()
			for item in top5 {
				if item.thumbnail.isNotEmpty {
					foundImage = item.thumbnail
					break
				}
			}
			
			if foundImage.isEmpty {
				self.image =  UIImage(systemName: "waveform.path",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
				self.layer.borderWidth = 1 	//waveform image always has border
				self.layer.borderColor = HILIGHT_CELL_COLOR.cgColor
			}else{
				self.image =  UIImage(data: foundImage)
				self.layer.borderWidth = 0
			}
			
			
			
			
		}else{
			if let thumbnail = findChildImage(group: group) {
				self.image =  UIImage(data: thumbnail)
				self.layer.borderWidth = 0
			} else {
				self.image =  UIImage(systemName: "waveform.path",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
				self.layer.borderWidth = 1 	//waveform image always has border
				self.layer.borderColor = HILIGHT_CELL_COLOR.cgColor
			}
		}
		
	}
	
	public func setImageForApp(thumbnail:Data,title:String, char2:String = ""){
		
		//defult circle
		self.backgroundColor = UIColor.clear;
		self.layer.cornerRadius =  self.frame.size.height / 2;
		self.layer.masksToBounds = true;
		
		//1.
		if thumbnail.count > 1 {
			self.image = UIImage(data: thumbnail)
			self.layer.borderWidth = 0
			return
		}
		
		//2.
		
		
		self.image =  UIImage(systemName: "waveform.path",withConfiguration: UIImage.SymbolConfiguration(weight: .ultraLight))
		self.layer.borderWidth = 1 		//waveform image always has border
		self.layer.borderColor = HILIGHT_CELL_COLOR.cgColor
		
	}
	
}
