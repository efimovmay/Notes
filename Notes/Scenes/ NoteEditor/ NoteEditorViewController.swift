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
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if noteTextView.text.trim() != "" {
			presenter?.saveNote(text: noteTextView.text)
		}
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
				top: Sizes.Padding.normal,
				left: Sizes.Padding.normal,
				bottom: keyboardViewEndFrame.height,
				right: Sizes.Padding.normal
			)
			noteTextView.scrollIndicatorInsets = noteTextView.contentInset
		}
		noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
	}
}

// MARK: - Setup UI
private extension NoteEditorViewController {
	
	func makeNoteTextView() -> UITextView {
		let textView = UITextView(frame: .zero, textContainer: nil)

		textView.backgroundColor = Theme.backgroundColor
		textView.contentInset = UIEdgeInsets(
			top: Sizes.Padding.normal,
			left: Sizes.Padding.normal,
			bottom: Sizes.Padding.normal,
			right: Sizes.Padding.normal
		)
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
		
		noteTextView.translatesAutoresizingMaskIntoConstraints = false
		
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			noteTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
			noteTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
			noteTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
			noteTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
		])
	}
}

// MARK: - IMainViewController
extension NoteEditorViewController: INoteEditorViewController {
	func render(viewData: NoteEditorModel.ViewData) {
		self.noteTextView.text = viewData.text
	}
}
