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
	var router: INoteListRouter?
	
	// MARK: - Private properties
	private var notes: [Note] = []

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
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.prefersLargeTitles = true
		presenter?.viewIsReady()
	}
}

// MARK: - Actions
private extension NotesListViewController {
	@objc
	func addTapped() {
		router?.routeToNoteEditor(note: nil)
	}
}

// MARK: - UITableView
extension NotesListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		notes.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let task = notes[indexPath.row]
		configureCell(cell, with: task)
		return cell
	}
	
	override func tableView(
		_ tableView: UITableView,
		commit editingStyle: UITableViewCell.EditingStyle,
		forRowAt indexPath: IndexPath
	) {
		if editingStyle == .delete {
			let note = getNoteForIndex(indexPath)
			presenter?.deleteNote(note: note)
			notes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let note = getNoteForIndex(indexPath)
		router?.routeToNoteEditor(note: note)
	}
}

// MARK: - UI setup
private extension NotesListViewController {
	func setupUI() {
		setupNavBar()
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}
	
	func setupNavBar() {
		title = L10n.NoteList.title
		
		let navBarAppearance = UINavigationBarAppearance()
		navBarAppearance.titleTextAttributes = [.foregroundColor: Theme.navBarTextColor]
		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Theme.navBarTextColor]
		navBarAppearance.backgroundColor = Theme.navBarColor
		
		navigationController?.navigationBar.tintColor = Theme.navBarTextColor
		navigationController?.navigationBar.standardAppearance = navBarAppearance
		navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addTapped)
		)
	}
	
	func getNoteForIndex(_ indexPath: IndexPath) -> Note {
		notes[indexPath.row]
	}
	
	func configureCell(_ cell: UITableViewCell, with note: Note) {
		var contentConfiguration = cell.defaultContentConfiguration()
		
		contentConfiguration.text = note.title
		
		cell.contentConfiguration = contentConfiguration
	}
}
// MARK: - IMainViewController
extension NotesListViewController: INotesListViewController {

	func render(viewData: NotesListModel.ViewData) {
		self.notes = viewData.notes
		tableView.reloadData()
	}
}
