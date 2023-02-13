//
//  RecallGroup.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import Foundation


public enum PIECE_STEP_NUMBER_ENUM:Int, Codable {
	case unknown = 0
	case step_number1
	case step_number2
	case step_number3
	case step_number4
}

public enum sort_items_enum:Int, Codable {
	case alpha = 0
	case sortorder
	case lastactivity
}


public enum contenttype_enum : Int,Codable {
	case primary = 0	//i.e. for law cases
	case secondary		//i.e. for law statutes
	case tertiary		//i.e. for law definitions
	case quad			//i.e. for udemy chants - lines
}



public class RecallGroup : NSObject, Codable,NSCopying {
	
	
	private enum CodingKeys: String, CodingKey {
		case UID = "UID"
		case title = "title"
		case subtitle = "subtitle" //used in yoga chants
		case hidden = "hidden"
		
		case isGroupMerged = "isGroupMerged"
		case imagecount = "imagecount" //fb duplication
		case itemcount = "itemcount" //fb duplication
		
		case hasParent = "hasParent"
		case hasChild = "hasChild"
		case groupUIDList = "groupUIDList"
		case stepNumber = "stepNumber"
		case hasAudio = "hasAudio"
		case lastactivity = "lastactivity"
		case origin = "origin"
		case sortitems = "sortitems"
		case canbeperformed = "canbeperformed"
		case contenttype = "contenttype"
		case schemeUID = "schemeUID"
		case thumbnail = "thumbnail"
		case prompt = "prompt"
		case pinnedItemUID = "pinnedItemUID"
		case lastsampletimestamp = "lastsampletimestamp"
		case systemhidden = "systemhidden"
		case systemhiddentimestamp = "systemhiddentimestamp"
		case cloudidentifiers = "cloudidentifiers"
		
		
	}
	
	// MARK:- NSCopying
	
	
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		UID =  try values.decodeIfPresent(String.self, forKey: .UID) ?? ""
		title =  try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		subtitle =  try values.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
		
		hidden =  try values.decodeIfPresent(Bool.self, forKey: .hidden) ?? false
		isGroupMerged =  try values.decodeIfPresent(Bool.self, forKey: .isGroupMerged) ?? false
		
		imagecount =  try values.decodeIfPresent(Int.self, forKey: .imagecount) ?? 0
		itemcount =  try values.decodeIfPresent(Int.self, forKey: .itemcount) ?? 0
		
		//group within group
		hasParent =  try values.decodeIfPresent(Bool.self, forKey: .hasParent) ?? false
		hasChild =  try values.decodeIfPresent(Bool.self, forKey: .hasChild) ?? false
		groupUIDList =  try values.decodeIfPresent([String].self, forKey: .groupUIDList) ?? [String]()
		cloudidentifiers =  try values.decodeIfPresent([String].self, forKey: .cloudidentifiers) ?? [String]()
		
		stepNumber =  try values.decodeIfPresent(PIECE_STEP_NUMBER_ENUM.self, forKey: .stepNumber) ?? PIECE_STEP_NUMBER_ENUM.step_number1
		hasAudio =  try values.decodeIfPresent(Bool.self, forKey: .hasAudio) ?? false
		lastsampletimestamp = RecallGroup.convertToDate(values, codingKey: .lastsampletimestamp)
		lastactivity = RecallGroup.convertToDate(values, codingKey: .lastactivity)
		
		do {
			origin =  try values.decodeIfPresent(origin_enum.self, forKey: .origin) ?? origin_enum.user
		} catch {
			if let originString = try values.decodeIfPresent(String.self, forKey: .origin) {
				switch originString.lowercased() {
					case "sample":origin = origin_enum.sample
					case "user":origin = origin_enum.user
					case "transfer":origin = origin_enum.transfer
					default:origin = origin_enum.user
				}
			}
		}
		
		
		do {
			sortitems =  try values.decodeIfPresent(sort_items_enum.self, forKey: .sortitems) ?? sort_items_enum.alpha
		} catch {
			
			if let originString = try values.decodeIfPresent(String.self, forKey: .sortitems) {
				switch originString.lowercased() {
					case "alpha":sortitems = sort_items_enum.alpha
					case "sortorder":sortitems = sort_items_enum.sortorder
					case "lastactivity":sortitems = sort_items_enum.lastactivity
					default:sortitems = sort_items_enum.alpha
				}
			}
		}
		
		canbeperformed =  try values.decodeIfPresent(Bool.self, forKey: .canbeperformed) ?? false //music and some yoga chants
		do {
			contenttype =  try values.decodeIfPresent(contenttype_enum.self, forKey: .contenttype) ?? contenttype_enum.primary
		} catch {
			if let originString = try values.decodeIfPresent(String.self, forKey: .contenttype) {
				switch originString.lowercased() {
					case "primary":contenttype = contenttype_enum.primary
					case "secondary":contenttype = contenttype_enum.secondary
					case "tertiary":contenttype = contenttype_enum.tertiary
					case "quad":contenttype = contenttype_enum.quad
					default:contenttype = contenttype_enum.primary
				}
			}
		}
		
		schemeUID = try values.decodeIfPresent(String.self, forKey: .schemeUID) ?? ""
		do {
			thumbnail =  try values.decodeIfPresent(Data.self, forKey: .thumbnail) ?? Data()
		} catch {
			thumbnail = Data()
		}
		do {
			prompt =  try values.decodeIfPresent(Data.self, forKey: .prompt) ?? Data()
		} catch {
			prompt = Data()
		}
		pinnedItemUID =  try values.decodeIfPresent(String.self, forKey: .pinnedItemUID) ?? ""
		
		//above lastactivity =  try values.decodeIfPresent(Date.self, forKey: .lastactivity) ?? Date()
		//Jun3 17 2021  - not yet used
		systemhidden =  try values.decodeIfPresent(Bool.self, forKey: .systemhidden) ?? false
		
		systemhiddentimestamp = RecallGroup.convertToDate(values, codingKey: .systemhiddentimestamp)
		
		
	}
	public func copy(with zone: NSZone? = nil) -> Any {
		
		let copy = RecallGroup()
		
		copy.isloading = true //dont save
		copy.UID = self.UID
		copy.title = self.title
		copy.subtitle = self.subtitle
		copy.hidden = self.hidden
		copy.isLinked = self.isLinked
		copy.isGroupMerged = self.isGroupMerged
		copy.imagecount = self.imagecount
		
		//Aug 2022 - were Missing
		copy.hasParent = self.hasParent
		copy.hasChild = self.hasChild
		copy.hasAudio = self.hasAudio
		copy.groupUIDList = self.groupUIDList
		copy.cloudidentifiers = self.cloudidentifiers
		//end
		
		copy.lastactivity = self.lastactivity //og item collection
		copy.itemcount = self.itemcount
		copy.itemList = self.itemList
		copy.images = self.images
		copy.stepNumber = self.stepNumber
		
		copy.origin = self.origin
		copy.sortitems = self.sortitems
		copy.canbeperformed = self.canbeperformed
		copy.contenttype = self.contenttype
		copy.schemeUID = self.schemeUID
		copy.thumbnail = self.thumbnail
		copy.prompt = self.prompt
		copy.pinnedItemUID = self.pinnedItemUID
		copy.lastsampletimestamp = self.lastsampletimestamp
		copy.systemhidden = self.systemhidden
		copy.systemhiddentimestamp = self.systemhiddentimestamp
		
		copy.isloading = false
		
		return copy
	}
	
	//used in downloading samples
	static func == (lhs: RecallGroup, rhs: RecallGroup) -> Bool {
		
		var returnValue = false
		
		if lhs.UID == rhs.UID && lhs.title == rhs.title && lhs.title == rhs.title && lhs.hasParent == rhs.hasParent && lhs.hasChild == rhs.hasChild {
			
			if lhs.hasChild  { //LinkedGroup - groupUIDList is now appropriate (hasChild already ==)
				if lhs.groupUIDList.count == rhs.groupUIDList.count && ( lhs.groupUIDList.count > 0) {
					for index in 0..<rhs.groupUIDList.count {
						if lhs.groupUIDList[index] == rhs.groupUIDList[index] {
							returnValue = true
						}
					}
				}
			}else{
				returnValue = true
			}
			
			
			
		}
		return returnValue
	}
	
	public static let transferJSONName = "transfer.json"
	public static let transferTempFolderName = "transfer"
	
	//MARK: - Properties
	public var isloading = false //so we dont updatre whilst reading in
	
	override public var description: String {
		
		return "\(title) UID:\(UID.prefix(4)) item count:\(itemList.count)"
	}
	
	public var DBID:Int = 0
	@objc public var UID:String = UUID().uuidString
	public var hidden = false
	
	public var title = ""
	public var subtitle = ""
	public var isLinked = false
	public var isGroupMerged = false //Not saved locally
	public var stepNumber:PIECE_STEP_NUMBER_ENUM = .step_number1
	public var itemList:[RecallItem] = [RecallItem]()
	public var otherItemList:[RecallItem] = [RecallItem]()
	public var images = [Data]() //score pages
	@objc public var hasParent = false
	@objc public var hasChild = false
	public var groupUIDList:[String] = [String]()
	public var cloudidentifiers:[String] = [String]()
	@objc public var hasAudio = false
	public var lastactivity = Date()
	public var lastsampletimestamp = Date()
	public var origin:origin_enum = .user
	public var sortitems:sort_items_enum = .alpha
	public var canbeperformed = false
	public var contenttype:contenttype_enum = .primary
	public var recordName = ""
	public var recordChangeTag = ""
	
	public var thumbnail:Data = Data()
	public var prompt:Data = Data() //larger version of above
	public var mainimage:Data = Data() //never saved
	public var imagecount = 0 //number of score pages - music firebase
	public var itemcount = 0  //number of items in this - group firebase
	public var schemeUID = ""
	public var pinnedItemUID = ""
	public var systemhidden = false
	public var systemhiddentimestamp = Date()
	//MARK: - Initializers
	override public init() {}
	
	
	//Note also saves to DB
	public func initWithTitle(_ title:String) -> RecallGroup{
		self.title = title
		return self
	}
	
	//Operations on Class
	public func unhideDepot(){
		if hidden {
			hidden = false //also Local
		}
	}

	// MARK: - Collection routines
	public func addItem(_ ri: RecallItem){
		
		itemList.append(ri) //copies!!
		
		ri.recallGroup = self;
		ri.busDepotUID = UID; //this will add to Local - if isLoading set
		
		
	}

}

extension RecallGroup {
	
	public func contentTypeString(singular:Bool = false) -> String {
		
		var returnValue = "memories" //default
		
		switch self.contenttype {
			case .primary:
				if singular {
					returnValue = "grouptype0singular"//.branded
				}else{
					returnValue = "grouptype0plural"//.branded
				}
			case .secondary:
				if singular {
					returnValue = "grouptype1singular"//.branded
				}else{
					returnValue = "grouptype1plural"//.branded
				}
			case .tertiary:
				if singular {
					returnValue = "grouptype2singular"//.branded
				}else{
					returnValue = "grouptype2plural"//.branded
				}
			case .quad:
				if singular {
					returnValue = "grouptype3singular"//.branded
				}else{
					returnValue = "grouptype3plural"//.branded
				}
		}
		
		
		
		
		return returnValue
		
		
	}
}
extension RecallGroup {
	
	private static func convertToDate(_ values: KeyedDecodingContainer<RecallGroup.CodingKeys>,codingKey:CodingKeys) -> Date {
		
		var returnValue = Date()
		
		do {
			returnValue =  try values.decodeIfPresent(Date.self, forKey: codingKey) ?? Date()
		} catch {
			let dateFormatterGet = DateFormatter()
			dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
			
			do {
				if let dateString = try values.decodeIfPresent(String.self, forKey: codingKey) {
					if let date = dateFormatterGet.date(from: dateString) { //convert string date
						returnValue =  date
					}
				}
			}catch{
				return returnValue
			}
			
		}
		return returnValue
	}
}
