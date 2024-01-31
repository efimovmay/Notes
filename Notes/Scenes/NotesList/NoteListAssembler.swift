//
//  NoteListAssembler.swift
//  Notes
//
//  Created by Aleksey Efimov on 31.01.2024.
//

import Foundation

final class NoteListAssembler {
	
	// MARK: - Dependencies
	private let coreDataManager: ICoreDataManager
	
	// MARK: - Initialization
	init(coreDataManager: ICoreDataManager) {
		self.coreDataManager = coreDataManager
	}
	
	// MARK: - Public methods
	func assembly() -> NotesListViewController {
		let viewController = NotesListViewController()
		let presenter = NotesListPresenter(view: viewController, coreDataManager: coreDataManager)
		
		return viewController
	}
}
