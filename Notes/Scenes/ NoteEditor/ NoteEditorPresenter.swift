//
//   NoteEditorPresenter.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import Foundation

/// Протокол презентера для отображения окна редактирования
protocol INoteEditorPresenter: AnyObject {
	
	/// Экран готов для отображения информации.
	func viewIsReady()
	
	/// Сохранение заметки
	func saveNote(text: String)
}

/// Презентер для окна редактирования
class NoteEditorPresenter: INoteEditorPresenter {
	
	weak var view: INoteEditorViewController! // swiftlint:disable:this implicitly_unwrapped_optional
	private let coreDataManager: ICoreDataManager
	private var note: Note?
	
	required init(view: INoteEditorViewController, coreDataManager: ICoreDataManager, note: Note?) {
		self.view = view
		self.coreDataManager = coreDataManager
		self.note = note
	}
	
	func viewIsReady() {
		if let newNote = note {
			view.render(viewData: NoteEditorModel.ViewData(text: newNote.text ?? ""))
		} else {
			view.render(viewData: NoteEditorModel.ViewData(text: ""))
		}
	}
	
	func saveNote(text: String) {
		if let updatedNote = note {
			updatedNote.text = text
			coreDataManager.update(updatedNote, newText: text)
		} else {
			coreDataManager.create(text)
		}
	}
}
