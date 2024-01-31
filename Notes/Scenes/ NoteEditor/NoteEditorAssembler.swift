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
	
	// MARK: - Initialization
	init(coreDataManager: ICoreDataManager) {
		self.coreDataManager = coreDataManager
	}
	
	// MARK: - Public methods
	func assembly() -> NoteEditorViewController {
		let viewController = NoteEditorViewController()
		let presenter = NoteEditorPresenter(view: viewController, coreDataManager: coreDataManager)

		return viewController
	}
}
