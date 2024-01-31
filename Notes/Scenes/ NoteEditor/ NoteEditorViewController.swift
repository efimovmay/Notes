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
	// MARK: - Private properties
	private var viewData = NoteEditorModel.ViewData(text: "")
	
	// MARK: - Dependencies
	var presenter: INotesListPresenter?
	
	// MARK: - Private properties
	private lazy var noteTextView = makeNoteTextView()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.noteTextView.resignFirstResponder()
	}
}

// MARK: - Setup UI
private extension NoteEditorViewController {
	func makeNoteTextView() -> UITextView {
		let textView = UITextView(frame: self.view.bounds)
		return textView
	}
	
	func setupUI() {
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardDidShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	@objc 
	func updateTextView(param: Notification) {
		let userInfo = param.userInfo
		// swiftlint:disable all
		let getKeyBoardrect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		// swiftlint:enable all
		let keyboardFrame = self.view.convert(getKeyBoardrect, to: view.window)
		
		if param.name == UIResponder.keyboardDidShowNotification {
			noteTextView.contentInset = UIEdgeInsets.zero
		} else {
			noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
			noteTextView.scrollIndicatorInsets = noteTextView.contentInset
		}
		noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
	}
}

// MARK: - Layout UI
private extension NoteEditorViewController {
	func layout() {
		view.addSubview(noteTextView)
	}
}

// MARK: - IMainViewController
extension NoteEditorViewController: INoteEditorViewController {
	func render(viewData: NoteEditorModel.ViewData) {
		self.viewData = viewData
		tableView.reloadData()
	}
}
