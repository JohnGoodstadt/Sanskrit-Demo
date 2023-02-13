//
//  RecallItem.swift
//  memorize_engine_framework
//
//  Created by John goodstadt on 19/02/2019.
//  Copyright © 2019 John goodstadt. All rights reserved.
//

import Foundation


public enum ANSWERED_ENUM : Int , Codable, CustomStringConvertible{
	case  NotAnswered = 0
	case  AnsweredInCorrect
	case  AnsweredCorrect
	
	public var description : String {
		switch self {
			case .NotAnswered: return "NotAnswered"
			case .AnsweredInCorrect: return "AnsweredInCorrect"
			case .AnsweredCorrect: return "AnsweredCorrect"
		}
	}
}

public enum BusCategory_Enum : Int, CustomStringConvertible,Codable, CaseIterable{
	case BusCategoryWords = 0    //default - this si actually BusCategory MemorizeNow -  Could be photo or words to remember
	case BusCategoryFaces
	case BusCategoryMusic
	case BusCategoryPlants
	case BusCategoryLanguage
	case BusCategoryArt
	case BusCategoryLegal
	case BusCategoryPeriodic
	case BusCategoryPlanet
	case BusCategoryYoga
	case BusCategoryYogaChants
	
	public var description : String {
		switch self {
			case .BusCategoryWords: return "Words"
			case .BusCategoryFaces: return "Faces"
			case .BusCategoryMusic: return "Music"
			case .BusCategoryPlants: return "Plants"
			case .BusCategoryLanguage: return "Language"
			case .BusCategoryArt: return "Art"
			case .BusCategoryLegal: return "Legal"
			case .BusCategoryPeriodic: return "Periodic"
			case .BusCategoryPlanet: return "Planet"
			case .BusCategoryYoga: return "Yoga" //also SanskritUdemy
			case .BusCategoryYogaChants: return "Chants"
		}
	}
	
}

public enum RecallItemType : Int, CustomStringConvertible,Codable{
	//REMBERING		PROMPT				E.G.
	case RecallItemTypeA = 0    // WORDS		TITLE				LAW/DEFINITIONS
	case RecallItemTypeB		// WORDS		IMAGE+TITLE/ANON	YOGA/PLANTS/FACES
	case RecallItemTypeC		// IMAGE		IMAGE+TITLE			U.S. STATES/YOGA
	case RecallItemTypeD		// IMAGE		TITLE/ANON			DEFINITIONS
	case RecallItemTypeE		// IMAGE/WORDS	IMAGE				SEE B - Words add to Image
	case RecallItemTypeF		// IMAGE/WORDS	IMAGE+TITLE/ANON	SEE C - Words add to Image
	case RecallItemTypeG		// IMAGE/WORDS	TITLE				SEE D - Words add to Image
	
	public var description : String {
		switch self {
			case .RecallItemTypeA: return "A"
			case .RecallItemTypeB: return "B"
			case .RecallItemTypeC: return "C"
			case .RecallItemTypeD: return "D"
			case .RecallItemTypeE: return "E"
			case .RecallItemTypeF: return "F"
			case .RecallItemTypeG: return "G"
		}
	}
	
}

public enum BUS_JOURNEY_STATE_ENUM : Int, CustomStringConvertible, Codable, CaseIterable{
	case JourneyStateInDepotSetup = 0 //default - not yet started (setup) all bits to memorize
	case JourneyStateInDepotLearning //now doing learning - before travelling (reviewing)
	case JourneyStateAtStop    // At Stop and Reviewing
	case JourneyStateTravellingOverdue  // Waiting but review needed
	case JourneyStateTravelling  // Waiting between stops
	case JourneyStateEnded //sucess at final stop
	case JourneyStateWaitingForOthers
	case Unknown
	
	public var description : String {
		switch self {
			case .JourneyStateInDepotSetup: return "Setup"
			case .JourneyStateInDepotLearning: return "Learning"
			case .JourneyStateAtStop: return "Recalling"
			case .JourneyStateTravellingOverdue: return "Ready for Prompting"
			case .JourneyStateTravelling: return "Not Yet Ready For Prompting"
			case .JourneyStateEnded: return "Ended"
			case .JourneyStateWaitingForOthers: return "Waiting for Others"
			case .Unknown: return "Unknown"
		}
	}
	
	public var audiodescription : String {
		switch self {
			case .JourneyStateInDepotSetup: return "Setup"
			case .JourneyStateInDepotLearning: return "Not Active"
			case .JourneyStateAtStop: return "Active"
			case .JourneyStateTravellingOverdue: return "Active and due"
			case .JourneyStateTravelling: return "Active but not due"
			case .JourneyStateEnded: return "Ended"
			case .JourneyStateWaitingForOthers: return "Waiting for Others"
			case .Unknown: return "Unknown"
		}
	}
}

public enum BUS_TIMINGS_STATE_ENUM : Int, Codable {
	case BUS_TIMINGS_STATE_OVERDUE = 0 //default - not yet started (setup) all bits to memorize
	case BUS_TIMINGS_STATE_EARLY //now doing learning - before travelling (reviewing)
	case BUS_TIMINGS_STATE_IN_WINDOW_EARLY    // At Stop and Reviewing
	case BUS_TIMINGS_STATE_IN_WINDOW_LATE  // Waiting but review needed
	case BUS_TIMINGS_STATE_DUE //  new case - if 1 week wait and it is today then it is due all today
}

//
public enum TABLE_SECTION_STATE_ENUM : Int, CustomStringConvertible, Codable {
	case TableSectionStateSetup = 0 //default - not yet started (setup) all bits to memorize
	case TableSectionStateLearning //now doing learning - before travelling (reviewing)
	case TableSectionStateStop    // At Stop and Reviewing
	case TableSectionStateOverdue  // Waiting but review needed
	case TableSectionStateTravelling  // Waiting between stops
	case TableSectionStateEnded //sucess at final stop
	// do i need JourneyStateWaitingForOthers
	case TableSectionStateUnknown
	case Unknown
	
	public var description : String {
		switch self {
			case .TableSectionStateSetup: return "Setup"
			case .TableSectionStateLearning: return "Learning"
			case .TableSectionStateStop: return "Recalling"
			case .TableSectionStateOverdue: return "Ready for Prompting"
			case .TableSectionStateTravelling: return "Not Yet Ready For Prompting"
			case .TableSectionStateEnded: return "Ended"
			case .TableSectionStateUnknown: return "Unknown"
			case .Unknown: return "Unknown"
		}
	}
	
}

// public class RecallItem : NSObject ,RecallItemLocalSQL, Hashable   {
final public class RecallItem : NSObject , Codable,NSCopying, Identifiable    {
	
	
	private enum CodingKeys: String, CodingKey {
		case UID
		case intUID
		case title
		case subtitle
		case hint
		case busDepotUID
		case phrase
		case cue
		case extraInfo
		case goTime
		case learnTime
		case prevEventTime
		case nextEventTime
		case answeredState
		case busCategory
		case recallItemType// missing on some fb rows
		case journeyState
		case origin
		case promptAsImage
		case words
		case metronome
		case currentBusStopNumber
		case schemeUID
		case schemeTitles
		case linkedPhrases
		case isCombined
		case phraseStopTiming
		case thumbnail
		//		case prompt //not read/written for user row - aug 4 2021
		case mainimage //TODO: should I move this to images colection
		
		case imagecount //should be same as images.count in Firestore - no big deal if wrong
		//		case audio //not read/written for user row - aug 4 2021
		case hasAudio
		case sortorder
		case doubleday
		case doubledaycount
		case doubledaycurrent
		case learntcounter
		case cantransfer
		case cantransferdate
		case lastactivity
		case char2 //2 char for small icon
		case hasPrompt
		case lastsampletimestamp
		//TODO: NOTE JUST FOR TRANSFERS  - ONE OFF - 18 MAY 2020
		//		case images //not filled - seperate collection in Firestore
	}
	
	//reusing this - for replace element in array
	//	static func == (lhs: RecallItem, rhs: RecallItem) -> Bool {
	//        return lhs.UID == rhs.UID
	//    }
	//NSObject version
	override public var description: String {
		
		return "UID:\(UID.prefix(4)) title:\(title) "
	}
	
	override public func isEqual(_ object: Any?) -> Bool {
		return UID == (object as? RecallItem)?.UID
	}
	//used in downloading samples
	
	static func == (lhs: RecallItem, rhs: RecallItem) -> Bool {
		
		var returnValue = false
		
		if lhs.UID == rhs.UID && lhs.title == rhs.title && lhs.words == rhs.words  {
			
			if lhs.prompt.count == rhs.prompt.count && lhs.thumbnail.count == rhs.thumbnail.count{
				returnValue = true //onyl true match
			}
		}
		return returnValue
	}
	
	
	override public var hash: Int {
		return UID.hashValue
	}
	
	override public init() {}
	
	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		
		
		UID =  try values.decodeIfPresent(String.self, forKey: .UID) ?? ""
		intUID =  try values.decodeIfPresent(Int.self, forKey: .intUID) ?? 0
		title =  try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		subtitle =  try values.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
		hint =  try values.decodeIfPresent(String.self, forKey: .hint) ?? ""
		busDepotUID =  try values.decodeIfPresent(String.self, forKey: .busDepotUID) ?? ""
		phrase =  try values.decodeIfPresent(String.self, forKey: .phrase) ?? ""
		cue =  try values.decodeIfPresent(String.self, forKey: .cue) ?? ""
		extraInfo =  try values.decodeIfPresent(String.self, forKey: .extraInfo) ?? ""
		
		/*
		 goTime =  try values.decodeIfPresent(Date.self, forKey: .goTime) ?? Date()
		 learnTime =  try values.decodeIfPresent(Date.self, forKey: .learnTime) ?? Date()
		 prevEventTime =  try values.decodeIfPresent(Date.self, forKey: .prevEventTime) ?? Date()
		 nextEventTime =  try values.decodeIfPresent(Date.self, forKey: .nextEventTime) ?? Date()
		 
		 */
		
		goTime = RecallItem.convertToDate(values, codingKey: .goTime)
		learnTime = RecallItem.convertToDate(values, codingKey: .learnTime)
		prevEventTime = RecallItem.convertToDate(values, codingKey: .prevEventTime)
		nextEventTime = RecallItem.convertToDate(values, codingKey: .nextEventTime)
		
		answeredState = RecallItem.convertToENUM(values, codingKey: .answeredState)
		
		busCategory = RecallItem.convertToCategory(values, codingKey: .busCategory)
		
		recallItemType =  try values.decodeIfPresent(RecallItemType.self, forKey: .recallItemType) ?? RecallItemType.RecallItemTypeA
		journeyState = RecallItem.convertToJourney(values, codingKey: .journeyState)
		
		origin = RecallItem.convertToOrigin(values, codingKey: .origin)
		
		promptAsImage =  try values.decodeIfPresent(Bool.self, forKey: .promptAsImage) ?? false
		words =  try values.decodeIfPresent(String.self, forKey: .words) ?? ""
		metronome =  try values.decodeIfPresent(String.self, forKey: .metronome) ?? ""
		currentBusStopNumber =  try values.decodeIfPresent(Int.self, forKey: .currentBusStopNumber) ?? 1
		
		schemeUID =  try values.decodeIfPresent(String.self, forKey: .schemeUID) ?? DEFAULT_SCHEME_UID
		schemeTitles =  try values.decodeIfPresent(String.self, forKey: .schemeTitles) ?? ""
		linkedPhrases =  try values.decodeIfPresent(String.self, forKey: .linkedPhrases) ?? ""
		
		isCombined =  try values.decodeIfPresent(Bool.self, forKey: .isCombined) ?? false
		phraseStopTiming =  try values.decodeIfPresent(String.self, forKey: .phraseStopTiming) ?? ""
		do {
			thumbnail =  try values.decodeIfPresent(Data.self, forKey: .thumbnail) ?? Data()
		} catch {
			thumbnail = Data()
		}
		//prompt is now not in ri record but seperated out - removed Aug 4 2021
		do {
			prompt =  try values.decodeIfPresent(Data.self, forKey: .thumbnail) ?? Data()
		} catch {
			prompt = Data()
		}
		//		mainimage = try values.decodeIfPresent(Data.self, forKey: .mainimage) ?? Data()
		do {
			mainimage =  try values.decodeIfPresent(Data.self, forKey: .mainimage) ?? Data()
		} catch {
			mainimage = Data()
		}
		imagecount =  try values.decodeIfPresent(Int.self, forKey: .imagecount) ?? 0
		//audio is now not in ri record but seperated out - removed Aug 4 2021
		audio =   Data()//try values.decodeIfPresent(Data.self, forKey: .audio) ?? Data()
		
		
		sortorder =  try values.decodeIfPresent(Int.self, forKey: .sortorder) ?? 0
		doubleday = try values.decodeIfPresent(Bool.self, forKey: .doubleday) ?? false
		doubledaycount = try values.decodeIfPresent(Int.self, forKey: .doubledaycount) ?? 40 //days
		doubledaycurrent = try values.decodeIfPresent(String.self, forKey: .doubledaycurrent) ?? ""
		learntcounter = try values.decodeIfPresent(Int.self, forKey: .learntcounter) ?? 0
		cantransfer = try values.decodeIfPresent(Bool.self, forKey: .cantransfer) ?? false
		cantransferdate = RecallItem.convertToDate(values, codingKey: .cantransferdate)
		lastactivity = RecallItem.convertToDate(values, codingKey: .lastactivity)
		char2 =  try values.decodeIfPresent(String.self, forKey: .char2) ?? ""
		
		//Jan 2021
		hasAudio = try values.decodeIfPresent(Bool.self, forKey: .hasAudio) ?? false
		hasPrompt = try values.decodeIfPresent(Bool.self, forKey: .hasPrompt) ?? false
		lastsampletimestamp = RecallItem.convertToDate(values, codingKey: .lastsampletimestamp)
	}
	
	public func copy(with zone: NSZone? = nil) -> Any {
		
		
		let copy = RecallItem()
		
		copy.isloading = true //dont save
		copy.UID = self.UID
		copy.title = self.title
		copy.subtitle = self.subtitle
		copy.hint = self.hint
		copy.intUID = self.intUID
		copy.busDepotUID = self.busDepotUID
		copy.phrase = self.phrase
		copy.cue = self.cue
		copy.extraInfo = self.extraInfo
		copy.goTime = self.goTime
		copy.learnTime = self.learnTime
		copy.prevEventTime = self.prevEventTime
		copy.nextEventTime = self.nextEventTime
		copy.answeredState = self.answeredState
		copy.busCategory = self.busCategory
		copy.recallItemType = self.recallItemType
		copy.journeyState = self.journeyState
		copy.origin = self.origin
		copy.promptAsImage = self.promptAsImage
		copy.words = self.words
		copy.metronome = self.metronome
		copy.currentBusStopNumber = self.currentBusStopNumber
		copy.schemeUID = self.schemeUID
		copy.schemeTitles = self.schemeTitles
		copy.linkedPhrases = self.linkedPhrases
		copy.isCombined = self.isCombined
		copy.phraseStopTiming = self.phraseStopTiming
		copy.thumbnail = self.thumbnail
		copy.prompt = self.prompt
		copy.imagecount = self.imagecount
		copy.hasAudio = self.hasAudio
		copy.audio = self.audio
		copy.sortorder = self.sortorder
		copy.doubleday = self.doubleday
		copy.doubledaycount = self.doubledaycount
		copy.doubledaycurrent = self.doubledaycurrent
		copy.learntcounter = self.learntcounter
		copy.cantransfer = self.cantransfer
		copy.cantransferdate = self.cantransferdate
		copy.lastactivity = self.lastactivity
		copy.char2 = self.char2
		//		copy.hasAudio = self.hasAudio
		copy.hasPrompt = self.hasPrompt
		copy.lastsampletimestamp = self.lastsampletimestamp
		
		copy.isloading = false
		
		return copy
	}
	
	//MARK: - Properties
	
	public init(title:String) {
		
		self.title = title
	}
	
	public var isloading = false //so we dont updatre whilst reading in
	public var id:String = UUID().uuidString //swiftUI Identifiable
	public var DBID:Int = 0
	@objc public var UID = UUID().uuidString
	public var intUID:Int =  Int(arc4random_uniform(RANDOM_UPPER_LIMIT_INT))
	public var busDepotID:Int = 0
	public var busDepotUID = ""
	public var recallGroup:RecallGroup?// = RecallGroup()
	// public var busDepot:RecallGroup?
	
	public var phrase = ""
	public var cue = ""
	//redirect to 'cue'
	public var customTitle:String {
		get { return  cue as String  }
		set (value) {
			cue = value
		}
	}
	public var extraInfo = ""
	
	public var goTime:Date?
	public var learnTime:Date?
	public var prevEventTime:Date?
	public var nextEventTime:Date?
	public var updatedDate:Date? //do i need this?
	
	public var answeredState = ANSWERED_ENUM.NotAnswered
	public var busCategory = BusCategory_Enum.BusCategoryWords
	public var recallItemType = RecallItemType.RecallItemTypeA
	public var promptAsImage = false // calculated from busCategory April 2019 - BusCategoryFaces,BusCategoryPlants,BusCategoryMusic,BusCategoryArt
	
	//objc version of above
	public var busCategoryObjc: Int {
		get {
			return self.busCategory.rawValue
		}
		set(value){
			busCategory = BusCategory_Enum(rawValue: value) ?? .BusCategoryWords //re direct - works as long as numbers aligh in 2 enums
		}
		
	}
	
	public var journeyState = BUS_JOURNEY_STATE_ENUM.JourneyStateInDepotSetup
	public func isTravelling() -> Bool {
		if journeyState == .JourneyStateTravelling  || journeyState == .JourneyStateTravellingOverdue {
			return true
		}else{
			return false
		}
	}
	
	public var origin = origin_enum.user
	//objc version of above
	public var journeyStateObjc:Int {
		get {
			return self.journeyState.rawValue
		}
		set(value){
			journeyState = BUS_JOURNEY_STATE_ENUM(rawValue: value) ?? .JourneyStateAtStop //re direct - works as long as numbers align in 2 enums
		}
		
		
	}
	public var title = "" {
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: fb.title, value: self.title ,UID: self.UID) }
		}
	}
	public var subtitle = "" {
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: fb.subtitle, value: self.subtitle ,UID: self.UID) }
		}
	}
	public var hint = ""
	public var best2CharTitle = "" //calculated only - if no image then use 2 chars from title for image - speed optimisation only
	
	
	public var words = "" {
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "words", value: self.words ,UID: self.UID)
				
			}
			//             if !isloading { updatePropertyLocal(property: "words", value: words,UID: UID) }
		}
	}
	public var metronome = "" {
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "metronome", value: self.metronome ,UID: self.UID) }
			//             if !isloading { updatePropertyLocal(property: "metronome", value: metronome,UID: UID) }
		}
	}
	
	public var currentBusStopNumber = 1 {//NOTE BUS in DB name
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "currentBusStopNumber", value: self.currentBusStopNumber ,UID: self.UID) }
			//             if !isloading { updatePropertyLocal(property: "currentBusStopNumber", value: currentBusStopNumber,UID: UID) }
		}
	}
	//timings = scheme
	public var schemeUID = "" {
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "schemeUID", value: self.schemeUID ,UID: self.UID) }
			
		}
	}
	//NOTE: this should cater for NOT JUST music
	public var schemeTitles = ""
	
	public var stops = [String]() //filled when necessary with schemeTitles as array
	public var stopCount:Int {
		get {
			var returnValue = 0
			
			if self.schemeTitles.count > 0 {
				self.stops = schemeTitles.components(separatedBy: ",")
				returnValue = self.stops.count;
			}
			
			
			return returnValue
		}
	}
	
	public var linkedPhrases = ""  { //other busUIDs that are treated as one for learn/review - concatenate Phrases
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "linkedPhrases", value: self.linkedPhrases ,UID: self.UID) }
			//             if !isloading { updatePropertyLocal(property: "linkedPhrases", value: linkedPhrases,UID: UID) }
		}
	}
	public var isCombined = false //do I need this? - Step 3?
	public var phraseStopTiming = "1W"
	
	public var recordName = ""
	public var recordChangeTag = ""
	
	public var thumbnail:Data = Data()
	public var prompt:Data = Data() //larger version of above
	public var mainimage:Data = Data() //not stored in fb
	public var images:[Data] = [Data]() //either use mainimage or this
	public var audio:Data = Data() //store data for user's spoken in to microphone - check here or in samples audio list - used in Pronounce app
	public var hasAudio = false {
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "hasAudio", value: self.hasAudio ,UID: self.UID)
				
			}
		}
	}
	public var imagecount:Int = 0 { //should be same as images.count in Firestore - no big deal if wrong
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "imagecount", value: self.imagecount ,UID: self.UID)
				
			}
		}
	}
	public var sortorder:Int = 0 { //within recall group
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: fb.sortorder, value: self.sortorder ,UID: self.UID)
			}
		}
	}
	//TODO: when samples have doubleday this can be saved in fb
	public var singleday:Bool { //computed property - //if true then after day 1, once a day - "1D,2D,5D,10D..."
		return !self.doubleday
	}
	public var doubleday = false { //if true then twice a day - "1D,2D,3D,4D..." twice each day for sequence.
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "doubleday", value: self.doubleday ,UID: self.UID)
			}
		}
	}
	public var doubledaycount = 40 //days
	public var doubledaycurrent = ""
	public var learntcounter = 0 { //e.g. 15 is heard/learnt 15 times
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: fb.learntcounter, value: self.learntcounter ,UID: self.UID)
			}
		}
	}
	public var cantransfer = false { //if true another can copy this record by the rules on fb
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "cantransfer", value: self.cantransfer ,UID: self.UID)
			}
		}
	}
	
	public var cantransferdate:Date?  {
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "cantransferdate", value: self.cantransferdate ,UID: self.UID) }
		}
	}
	
	public var lastactivity = Date()  {
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "lastactivity", value: self.lastactivity ,UID: self.UID) }
		}
	}
	public var char2 = ""  { //other busUIDs that are treated as one for learn/review - concatenate Phrases
		didSet(value){
			//if !isloading { updatePropertyFirestore(property: "char2", value: self.char2 ,UID: self.UID) }
		}
	}
	public var hasPrompt = false {
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "hasPrompt", value: self.hasPrompt ,UID: self.UID)
				
			}
		}
	}
	public var lastsampletimestamp = Date(timeIntervalSince1970: 0) {
		didSet(value){
			if !isloading {
				//updatePropertyFirestore(property: "lastsampletimestamp", value: self.lastsampletimestamp ,UID: self.UID)
				
			}
		}
	}
	
	public func desc () -> String{
		if let nextEventTime = nextEventTime {
			return "\(title), \(journeyState.description), \(String(describing: nextEventTime)), images:\(images.count)"
		}else{
			return "\(title), \(journeyState.description), images:\(images.count)"
		}
	}
	
}

internal extension RecallItem {
	
	private static func convertToDate(_ values: KeyedDecodingContainer<RecallItem.CodingKeys>,codingKey:CodingKeys) -> Date {
		
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
	private static func convertToENUM(_ values: KeyedDecodingContainer<RecallItem.CodingKeys>,codingKey:CodingKeys) -> ANSWERED_ENUM {
		
		var returnValue = ANSWERED_ENUM.NotAnswered
		
		do {
			returnValue =  try values.decodeIfPresent(ANSWERED_ENUM.self, forKey: codingKey) ?? ANSWERED_ENUM.NotAnswered
		} catch {
			do {
				if let decoded = try values.decodeIfPresent(String.self, forKey: codingKey) {
					switch decoded {
						case ANSWERED_ENUM.NotAnswered.description:returnValue = ANSWERED_ENUM.NotAnswered
						case ANSWERED_ENUM.AnsweredInCorrect.description:returnValue = ANSWERED_ENUM.AnsweredInCorrect
						case ANSWERED_ENUM.AnsweredCorrect.description:returnValue = ANSWERED_ENUM.AnsweredCorrect
						default:
							returnValue = ANSWERED_ENUM.NotAnswered
					}
				}
			}catch{
				return returnValue
			}
		}
		return returnValue
	}
	private static func convertToCategory(_ values: KeyedDecodingContainer<RecallItem.CodingKeys>,codingKey:CodingKeys) -> BusCategory_Enum {
		
		var returnValue = BusCategory_Enum.BusCategoryWords
		
		do {
			returnValue =  try values.decodeIfPresent(BusCategory_Enum.self, forKey: codingKey) ?? BusCategory_Enum.BusCategoryWords
		} catch {
			do {
				if let decoded = try values.decodeIfPresent(String.self, forKey: codingKey) {
					
					for item in BusCategory_Enum.allCases {
						if item.description == decoded {
							return item
						}
					}
					
					//					switch decoded {
					//						case BusCategory_Enum.BusCategoryWords.description:returnValue = BusCategory_Enum.BusCategoryWords
					//						case BusCategory_Enum.BusCategoryMusic.description:returnValue = BusCategory_Enum.BusCategoryMusic
					//						case BusCategory_Enum.BusCategoryLegal.description:returnValue = BusCategory_Enum.BusCategoryLegal
					//						default:
					//							returnValue = BusCategory_Enum.BusCategoryWords
					//					}
				}
			}catch{
				return returnValue
			}
		}
		return returnValue
	}
	private static func convertToJourney(_ values: KeyedDecodingContainer<RecallItem.CodingKeys>,codingKey:CodingKeys) -> BUS_JOURNEY_STATE_ENUM {
		
		var returnValue = BUS_JOURNEY_STATE_ENUM.JourneyStateInDepotLearning
		
		do {
			returnValue =  try values.decodeIfPresent(BUS_JOURNEY_STATE_ENUM.self, forKey: codingKey) ?? BUS_JOURNEY_STATE_ENUM.JourneyStateInDepotLearning
		} catch {
			do {
				if let decoded = try values.decodeIfPresent(String.self, forKey: codingKey) {
					
					for item in BUS_JOURNEY_STATE_ENUM.allCases {
						if item.description == decoded {
							return item
						}
					}
				}
			}catch{
				return returnValue
			}
		}
		return returnValue
	}
	private static func convertToOrigin(_ values: KeyedDecodingContainer<RecallItem.CodingKeys>,codingKey:CodingKeys) -> origin_enum {
		
		var returnValue = origin_enum.user
		
		do {
			returnValue =  try values.decodeIfPresent(origin_enum.self, forKey: codingKey) ?? origin_enum.user
		} catch {
			do {
				if let decoded = try values.decodeIfPresent(String.self, forKey: codingKey) {
					
					for item in origin_enum.allCases {
						if item.description == decoded {
							return item
						}
					}
				}
			}catch{
				return returnValue
			}
		}
		return returnValue
	}
}


