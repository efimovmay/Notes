//
//  Strings+trim.swift
//  Notes
//
//  Created by Aleksey Efimov on 01.02.2024.
//

import Foundation

extension String {
	func trim() -> String {
		return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
	}
}
