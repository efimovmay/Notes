//
//  CoreDataManager.swift
//  Notes
//
//  Created by Aleksey Efimov on 30.01.2024.
//

import Foundation
import CoreData

protocol ICoreDataManager {	
	func create(_ text: String)
	func fetchData(completion: (Result<[Note], Error>) -> Void)
	func update(_ note: Note, newText: String)
	func deleteNote(_ note: Note)
	func saveContext()
}

final class CoreDataManager: ICoreDataManager {
	
	// MARK: - Core Data stack
	private let persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Notes")
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
	
	private let viewContext: NSManagedObjectContext
	
	init() {
		viewContext = persistentContainer.viewContext
	}
	
	// MARK: - CRUD
	func create(_ text: String) {
		let note = Note(context: viewContext)
		note.id = UUID()
		note.text = text
		saveContext()
	}
	
	func fetchData(completion: (Result<[Note], Error>) -> Void) {
		let fetchRequest = Note.fetchRequest()
		
		do {
			let tasks = try viewContext.fetch(fetchRequest)
			completion(.success(tasks))
		} catch let error { // swiftlint:disable:this untyped_error_in_catch
			completion(.failure(error))
		}
	}
	
	func update(_ note: Note, newText: String) {
		note.text = newText
		saveContext()
	}
	
	func deleteNote(_ note: Note) {
		viewContext.delete(note)
		saveContext()
	}
	
	// MARK: - Core Data Saving support
	func saveContext() {
		if viewContext.hasChanges {
			do {
				try viewContext.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
