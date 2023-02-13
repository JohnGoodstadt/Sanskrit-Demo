//
//  Models.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import Foundation

public enum image_type_enum : Int, CustomStringConvertible,Codable{
	
	case image = 0   // used for image collection - an image not an audio
	case audio		// used for image collection - an mp3 not image
	public var description : String {
		switch self {
			case .image: return "Image"
			case .audio: return "Audio"
		}
	}
	
}
public enum image_owner_enum : Int, CustomStringConvertible,Codable{
	
	case item = 0   // used for image collection - owned by an item
	case group		// used for image collection - owned by a group
	public var description : String {
		switch self {
			case .item: return "item"
			case .group: return "group"
		}
	}
	
}
public class ImageDocument : Codable {
	public var UID:String = "not_set" //either recallitem or recallgroup UID
	public var page = 1
	public var image:Data = Data()
	public var imageType = image_type_enum.image
	public var image_owner = image_owner_enum.item
	
	public init(_ UID:String,_ page:Int,_ image:Data){
		self.UID = UID
		self.page = page
		self.image = image
		self.imageType = .image //most common
		self.image_owner = .item //most common
	}
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		UID =  try values.decodeIfPresent(String.self, forKey: .UID) ?? "note set"
		image =  try values.decodeIfPresent(Data.self, forKey: .image) ?? Data()
		page =  try values.decodeIfPresent(Int.self, forKey: .page) ?? 1
		imageType =  try values.decodeIfPresent(image_type_enum.self, forKey: .imageType) ?? image_type_enum.image
		image_owner =  try values.decodeIfPresent(image_owner_enum.self, forKey: .imageType) ?? image_owner_enum.item
		
	}
	
	public static func docName(_ UID:String,_ page:Int) -> String {
		return "\(UID)_\(page)"
	}
}
public class AudioDocument : Codable {
	public var UID = "" // either item or group
	public var audio:Data = Data()
	//var imageType = image_type_enum.image
	public var owner = image_owner_enum.item //most likely
	public var name = ""
	public var totalheardcounter = 0
	public var uploaddate = Date()
	
	public init(_ UID:String,_ audio:Data, name:String = "undefined"){
		
		self.UID = UID
		self.audio = audio
		//self.imageType = .audio //most common
		self.owner = image_owner_enum.item
		self.name = name
		self.uploaddate = Date()
	}

	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		UID  =  try values.decodeIfPresent(String.self, forKey: .UID) ?? ""
		audio =  try values.decodeIfPresent(Data.self, forKey: .audio) ?? Data()
		owner =  try values.decodeIfPresent(image_owner_enum.self, forKey: .owner) ?? image_owner_enum.item
		name  =  try values.decodeIfPresent(String.self, forKey: .name) ?? "undefined 2"
		do {
			uploaddate = try values.decodeIfPresent(Date.self, forKey: .uploaddate) ?? Date()
		}catch {
			uploaddate = Date()
		}
		
		do {
			totalheardcounter  =  try values.decodeIfPresent(Int.self, forKey: .totalheardcounter) ?? 0
		}catch {
			totalheardcounter  =  0
		}
		
	}
}

