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
		
		checkNotes()
		
		let navigationController = UINavigationController()
		navigationController.pushViewController(assembly(navigationController: navigationController), animated: false)
		
		window.rootViewController = navigationController
		window.makeKeyAndVisible()
		
		self.window = window
	}
	
	func assembly(navigationController: UINavigationController) -> UIViewController {
		let notesListViewController = NoteListAssembler(coreDataManager: coreDataManager).assembly()
		
		let noteListRouter = NoteListRouter(
			navigationController: navigationController,
			coreDataManager: coreDataManager
		)
		notesListViewController.router = noteListRouter
		
		return notesListViewController
	}
	
	func checkNotes() {
		coreDataManager.fetchData { [unowned self] result in
			switch result {
			case .success(let notes):
				if notes.isEmpty {
					coreDataManager.create("Первая заметка")
				}
			case .failure(let error):
				print(error.localizedDescription) // swiftlint:disable:this print_using
			}
		}
	}
}
