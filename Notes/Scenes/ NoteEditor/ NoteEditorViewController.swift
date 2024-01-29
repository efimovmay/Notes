//
//   NoteEditorViewController.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import UIKit

/// Протокол  экрана редактирования.
protocol INoteEditorViewController: AnyObject {
	
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewData: NoteEditorModel.ViewData)
}

/// Экран редактирования заметки.
final class NoteEditorViewController: UITableViewController {
}

// MARK: - IMainViewController
extension NoteEditorViewController: INoteEditorViewController {
	
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewData: NoteEditorModel.ViewData) {
//		self.viewData = viewData
		tableView.reloadData()
	}
}
