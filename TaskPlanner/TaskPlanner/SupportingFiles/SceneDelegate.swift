//
//  SceneDelegate.swift
//  TaskPlanner
//
//  Created by Matvei Khlestov on 01.07.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var storageManager = StorageManager.shared
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(
            rootViewController: TasksViewController()
        )
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        storageManager.saveContext()
    }
}

