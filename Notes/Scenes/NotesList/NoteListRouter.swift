//
//  NoteListRouter.swift
//  Notes
//
//  Created by Aleksey Efimov on 31.01.2024.
//

import UIKit

protocol INoteListRouter {
	func routeToNoteEditor()
	func backToNoteList()
}
 
final class NoteListRouter: INoteListRouter {
	// MARK: - Dependencies
	
	private let navigationController: UINavigationController
	private let nextViewController: UIViewController
	
	// MARK: - Initialization
	init(navigationController: UINavigationController, nextViewController: UIViewController) {
		self.navigationController = navigationController
		self.nextViewController = nextViewController
	}
	
	// MARK: - Public methods
	func routeToNoteEditor() {
		navigationController.pushViewController(nextViewController, animated: true)
	}
	
	func backToNoteList() {
		navigationController.popViewController(animated: true)
	}
}
