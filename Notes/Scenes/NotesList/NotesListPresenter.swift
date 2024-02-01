//
//  NotesListPresenter.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import Foundation

/// Протокол презентера для отображения главного экрана.
protocol INotesListPresenter: AnyObject {

	/// Экран готов для отображения информации.
	func viewIsReady()
	/// Удаление заметки.
	func deleteNote(note: Note)
}

/// Презентер для главного экрана
final class NotesListPresenter: INotesListPresenter {
	
	weak var view: INotesListViewController! // swiftlint:disable:this implicitly_unwrapped_optional
	private let coreDataManager: ICoreDataManager
	private var notes: [Note] = []

	required init(view: INotesListViewController, coreDataManager: ICoreDataManager) {
		self.view = view
		self.coreDataManager = coreDataManager
	}
	
	func viewIsReady() {
		view.render(viewData: mapViewData())
	}
	
	private func mapViewData() -> NotesListModel.ViewData {
		coreDataManager.fetchData { [unowned self] result in
			switch result {
			case .success(let notes):
				self.notes = notes
			case .failure(let error):
				print(error.localizedDescription) // swiftlint:disable:this print_using
			}
		}
	
		return NotesListModel.ViewData(notes: notes)
	}
	
	func deleteNote(note: Note) {
		coreDataManager.deleteNote(note)
	}
}
