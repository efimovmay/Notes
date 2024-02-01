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
	
	// MARK: - Dependencies
	var presenter: INoteEditorPresenter?
	var note: Note?
	
	// MARK: - Private properties
	private lazy var noteTextView: UITextView = makeNoteTextView()

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter?.viewIsReady()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = false
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
		presenter?.viewIsReady()
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		presenter?.saveNote(text: noteTextView.text)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.noteTextView.resignFirstResponder()
	}
	
	@objc
	func updateTextView(notification: Notification) {
		// swiftlint:disable all
		let userInfo = notification.userInfo
		let keyboardScreenEndFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		// swiftlint:enable all
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			noteTextView.contentInset = UIEdgeInsets.zero
		} else {
			noteTextView.contentInset = UIEdgeInsets(
				top: 0,
				left: 0,
				bottom: keyboardViewEndFrame.height,
				right: 0
			)
			noteTextView.scrollIndicatorInsets = noteTextView.contentInset
		}
		noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
	}
}

// MARK: - Setup UI
private extension NoteEditorViewController {
	
	func makeNoteTextView() -> UITextView {
		let textView = UITextView(frame: CGRect(
			x: Sizes.Padding.normal,
			y: Sizes.Padding.normal,
			width: 300,
			height: 300
		))
		textView.backgroundColor = .gray
		textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		textView.isScrollEnabled = true
		textView.font = UIFont.systemFont(ofSize: Sizes.fontSizeEditor)
		
		return textView
	}
	
	func setupUI() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardDidHideNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(updateTextView),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
	}
}

// MARK: - Text View Delegate
extension NoteEditorViewController: UITextViewDelegate {
	func textViewDidEndEditing(_ textView: UITextView) {
		presenter?.saveNote(text: noteTextView.text)
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
		self.noteTextView.text = viewData.text
	}
}
