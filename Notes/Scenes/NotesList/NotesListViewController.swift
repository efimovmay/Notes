//
//  ViewController.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import UIKit

/// Протокол главного экрана приложения.
protocol INotesListViewController: AnyObject {
	
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewData: NotesListModel.ViewData)
}

/// Главный экран приложения.
final class NotesListViewController: UITableViewController {
	
	// MARK: - Dependencies
	var presenter: INotesListPresenter?
	
	// MARK: - Private properties
	private var viewData = NotesListModel.ViewData(notes: [])

	// MARK: - Initialization
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		presenter?.viewIsReady()
	}
}

// MARK: - Actions

private extension NotesListViewController {
	@objc
	func addTapped() {
	//	interactor?.createTask()
	}
}

// MARK: - UITableView

extension NotesListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewData.notes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let task = viewData.notes[indexPath.row]
		configureCell(cell, with: task)
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
}

// MARK: - UI setup
private extension NotesListViewController {
	private func setupUI() {
		title = L10n.NoteList.title
		navigationItem.setHidesBackButton(true, animated: true)
		navigationController?.navigationBar.prefersLargeTitles = true
		
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addTapped)
		)
	}
	
	func getNoteForIndex(_ indexPath: IndexPath) -> String {
		viewData.notes[indexPath.row]
	}
	
	func configureCell(_ cell: UITableViewCell, with note: String) {
		var contentConfiguration = cell.defaultContentConfiguration()

		contentConfiguration.text = note
		cell.contentConfiguration = contentConfiguration
	}
}
// MARK: - IMainViewController
extension NotesListViewController: INotesListViewController {
	
	/// Метод отрисовки информации на экране.
	/// - Parameter viewModel: данные для отрисовки на экране.
	func render(viewData: NotesListModel.ViewData) {
		self.viewData = viewData
		tableView.reloadData()
	}
}
