//
//  SceneDelegate.swift
//  Notes
//
//  Created by Aleksey Efimov on 29.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		
		window.rootViewController = UINavigationController(rootViewController: assemblyNotesList())
		window.makeKeyAndVisible()
		
		self.window = window
	}
	
	func assemblyNotesList() -> UIViewController {
		let viewController = NotesListViewController()
		let presenter = NotesListPresenter(view: viewController)
		viewController.presenter = presenter
		return viewController
	}
}
