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
	func viewIsReady() {
	}
}
