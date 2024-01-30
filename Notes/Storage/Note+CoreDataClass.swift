//
//  Note+CoreDataClass.swift
//  Notes
//
//  Created by Aleksey Efimov on 30.01.2024.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
	
	// Возвращает первую строку текста
	var title: String {
		return text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
	}
}
