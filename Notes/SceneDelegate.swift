//
//  SceneDelegate.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	private let coreDataManager = CoreDataManager()
	
	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		
		let navigationController = UINavigationController()
		navigationController.pushViewController(assembly(navigationController: navigationController), animated: false)
		
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		
		self.window = window
	}
	
	func assembly(navigationController: UINavigationController) -> UIViewController {
		let notesListViewController = NoteListAssembler(coreDataManager: coreDataManager).assembly()
		
		let noteEditorViewController = NoteEditorAssembler(coreDataManager: coreDataManager).assembly()
		
		let noteListRouter = NoteListRouter(
			navigationController: navigationController,
			nextViewController: noteEditorViewController
		)
		notesListViewController.router = noteListRouter
		
		return notesListViewController
	}
	
	func assemblyNotesList() -> UIViewController {
		let viewController = NotesListViewController()

		let presenter = NotesListPresenter(view: viewController, coreDataManager: coreDataManager)
		viewController.presenter = presenter
		return viewController
	}
}
