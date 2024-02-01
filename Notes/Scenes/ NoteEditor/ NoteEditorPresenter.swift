//
//   NoteEditorPresenter.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import Foundation

/// Протокол презентера для отображения главного экрана.
protocol INoteEditorPresenter: AnyObject {
	
	/// Экран готов для отображения информации.
	func viewIsReady()
}

/// Презентер для главного экрана
class NoteEditorPresenter: INoteEditorPresenter {
	
	weak var view: INoteEditorViewController! // swiftlint:disable:this implicitly_unwrapped_optional
	let coreDataManager: ICoreDataManager
	var note: Note?
	
	required init(view: INoteEditorViewController, coreDataManager: ICoreDataManager, note: Note?) {
		self.view = view
		self.coreDataManager = coreDataManager
		self.note = note
	}
	
	func viewIsReady() {
	}
}
