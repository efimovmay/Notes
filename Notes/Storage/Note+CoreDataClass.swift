//
//  Note+CoreDataClass.swift
//  Notes
//
//  Created by Aleksey Efimov on 30.01.2024.
//
//

import Foundation
import CoreData

public class Note: NSManagedObject {
	
	var title: String {
		return text?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
	}
	
//	var desc: String {
//		var lines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
//		lines.removeFirst()
//		return "\(lastUpdated.format()) \(lines.first ?? "")" // return second line
//	}
}
