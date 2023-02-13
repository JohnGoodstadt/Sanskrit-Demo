//
//  World.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import Foundation
import UIKit

var Current = World()

struct World {
	var items:[RecallItem] = .shared
	var groups:[RecallGroup] = .shared
}

extension Array where Element == RecallGroup {
	fileprivate static let shared = [RecallGroup]()
}
extension Array where Element == RecallItem {
	fileprivate static let shared = [RecallItem]()
}

