//
//  CoreDataManager.swift
//  Notes
//
//  Created by Aleksey Efimov on 30.01.2024.
//

import Foundation
import CoreData

protocol ICoreDataManager {	
	func load(completion: (() -> Void)?)
	func save()
	func createNote() -> Note
	func fetchNotes(filter: String?) -> [Note]
}

final class CoreDataManager: ICoreDataManager {
	
	// MARK: - Public properties
	let persistentContainer: NSPersistentContainer
	
	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}
	
	// MARK: - Initialization
	init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}
	
	// MARK: - Public methods
	func load(completion: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { (description, error) in
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}
			completion?()
		}
	}
	
	func save() {
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				print("An error ocurred while saving: \(error.localizedDescription)")
			}
		}
	}

	func createNote() -> Note {
		let note = Note(context: viewContext)
		note.id = UUID()
		note.text = ""
		note.lastUpdated = Date()
		save()
		return note
	}
	
	func fetchNotes(filter: String? = nil) -> [Note] {
		let request: NSFetchRequest<Note> = Note.fetchRequest()
		let sortDescriptor = NSSortDescriptor(keyPath: \Note.lastUpdated, ascending: false)
		request.sortDescriptors = [sortDescriptor]
		
		if let filter = filter {
			let predicate = NSPredicate(format: "text contains[cd] %@", filter)
			request.predicate = predicate
		}
		
		return (try? viewContext.fetch(request)) ?? []
	}
	
	func deleteNote(_ note: Note) {
		viewContext.delete(note)
		save()
	}
}
