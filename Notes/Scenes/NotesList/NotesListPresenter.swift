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
	
	/// Пользователь выбрал строку  в таблице.
	/// - Parameter indexPath: Индекс выбранной строки.
	func didTaskSelected(at indexPath: IndexPath)
}

/// Презентер для главного экрана
class NotesListPresenter: INotesListPresenter {
	
	weak var view: INotesListViewController! // swiftlint:disable:this implicitly_unwrapped_optional
	
	/// Инициализатор презентера
	/// - Parameters:
	///   - view: Необходимая вьюха, на которой будет выводиться информация;
	///   - taskManager: Источник информации для заданий.
	required init(view: INotesListViewController) {
		self.view = view
	}
	
	/// Обработка готовности экрана для отображения информации.
	func viewIsReady() {
		view.render(viewData: mapViewData())
	}
	
	/// Мапинг бизнес-моделей в модель для отображения.
	/// - Returns: Возвращает модель для отображения.
	private func mapViewData() -> NotesListModel.ViewData {
		let notes = ["1", "2"]
		return NotesListModel.ViewData(notes: notes)
	}
	
	/// Обработка выбранной пользователем строки таблицы.
	/// - Parameter indexPath: Индекс, который выбрал пользователь.
	func didTaskSelected(at indexPath: IndexPath) {

		view.render(viewData: mapViewData())
	}
}