//
//  NoteListRouter.swift
//  Notes
//
//  Created by Aleksey Efimov on 31.01.2024.
//

import UIKit

protocol INoteListRouter {
	func routeToNoteEditor(note: Note?)
}
 
final class NoteListRouter: INoteListRouter {
	// MARK: - Dependencies
	
	private let navigationController: UINavigationController
	private let coreDataManager: ICoreDataManager
	
	// MARK: - Initialization
	init(navigationController: UINavigationController, coreDataManager: ICoreDataManager) {
		self.navigationController = navigationController
		self.coreDataManager = coreDataManager
	}
	
	// MARK: - Public methods
	func routeToNoteEditor(note: Note?) {
		let noteEditorViewController = NoteEditorAssembler(coreDataManager: coreDataManager, note: note).assembly()
		navigationController.pushViewController(noteEditorViewController, animated: true)
	}
}
