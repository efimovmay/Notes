//
//  NoteEditorAssembler.swift
//  Notes
//
//  Created by Aleksey Efimov on 31.01.2024.
//

import Foundation

final class NoteEditorAssembler {
	
	// MARK: - Dependencies
	private let coreDataManager: ICoreDataManager
	private let note: Note?
	
	// MARK: - Initialization
	init(coreDataManager: ICoreDataManager, note: Note?) {
		self.coreDataManager = coreDataManager
		self.note = note
	}
	
	// MARK: - Public methods
	func assembly() -> NoteEditorViewController {
		let viewController = NoteEditorViewController()
		let presenter = NoteEditorPresenter(view: viewController, coreDataManager: coreDataManager, note: note)
		viewController.presenter = presenter
		
		return viewController
	}
}
