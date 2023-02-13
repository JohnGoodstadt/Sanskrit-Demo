//
//  String.swift
//  SanskritDemo
//
//  Created by John goodstadt on 11/02/2023.
//

import Foundation

extension String {
	
	var isNotEmpty:Bool {
		return !self.isEmpty
	}
	//https://stackoverflow.com/questions/29521951/how-to-remove-diacritics-from-a-string-in-swift
	var forNonDiatricicSorting: String {
		let simple = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: nil)
		let nonAlphaNumeric = CharacterSet.alphanumerics.inverted
		return simple.components(separatedBy: nonAlphaNumeric).joined(separator: "")
	}
}
