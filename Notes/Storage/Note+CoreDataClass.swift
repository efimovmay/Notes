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
		// возвращает первую строку текста
		return text?.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
	}
}
