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
	var presenter: INoteEditorPresenter?
	
	// MARK: - Private properties
	private lazy var noteTextView: UITextView = makeNoteTextView()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		noteTextView.becomeFirstResponder()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.noteTextView.resignFirstResponder()
	}
}

// MARK: - Setup UI
private extension NoteEditorViewController {
	
	func makeNoteTextView() -> UITextView {
		let textView = UITextView(frame: CGRect(
			x: Sizes.Padding.normal,
			y: Sizes.Padding.normal,
			width: self.view.bounds.width - (Sizes.Padding.normal * 2),
			height: self.view.bounds.height - (Sizes.Padding.normal * 4)
		))
		
		textView.isScrollEnabled = true
		textView.font = UIFont.systemFont(ofSize: Sizes.fontSizeEditor)
		
		return textView
	}
	
	func setupUI() {

		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardDidHideNotification,
			object: nil
		)
		notificationCenter.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardDidHideNotification,
			object: nil
		)
	}
	
	@objc
	func updateTextView(notification: Notification) {
		// swiftlint:disable all
		let userInfo = notification.userInfo!
		let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		// swiftlint:enable all
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: noteTextView.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			noteTextView.contentInset = UIEdgeInsets.zero
		} else {
			noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
		}
		
		noteTextView.scrollIndicatorInsets = noteTextView.contentInset
		
		let selectedRange = noteTextView.selectedRange
		noteTextView.scrollRangeToVisible(selectedRange)
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
