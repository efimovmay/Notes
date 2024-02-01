//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Aleksey Efimov on 30.01.2024.
//
//

import Foundation
import CoreData

extension Note {
	
	/// Модель note в CoreData
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
		return NSFetchRequest<Note>(entityName: "Note")
	}
	/// Идентификатор
	@NSManaged public var id: UUID?
	/// Тело заметки
	@NSManaged public var text: String?
}

extension Note: Identifiable {
}
