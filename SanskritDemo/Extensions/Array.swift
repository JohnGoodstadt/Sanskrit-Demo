//
//  Array.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import Foundation

public extension Array {
	
	var isNotEmpty:Bool {
		return !self.isEmpty
	}
	
	func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
		var dict = [Key:Element]()
		for element in self {
			dict[selectKey(element)] = element
		}
		return dict
	}
}
