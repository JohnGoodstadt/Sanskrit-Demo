//
//  OutlineDisplay.swift
//  memorize
//
//  Created by John goodstadt on 15/11/2022.
//  Copyright © 2022 John Goodstadt. All rights reserved.
//

import Foundation


enum ListenDisplay {
	enum LoadData {
		struct Request {}
		
		struct Response {
			var item: RecallItem
		}
		
		struct ViewModel {}
	}
	enum State {
		struct Request {}
		
		struct Response {
			var isPlaying:Bool
		}
	}
}
