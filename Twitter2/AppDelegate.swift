//
//  AppDelegate.swift
//  Twitter2
//
//  Created by Nursat Saduakhassov on 03.11.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var navController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupWindow()
        presentFeed()
        return true
    }
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    private func presentFeed() {
        let feed = FeedViewController()
        feed.onPlusButtonTap = { [weak self] in
            self?.presentEdit()
        }
        feed.onEdit = { [weak self] id, text in
            self?.presentEdit(id: id, text: text)
        }
        navController.setViewControllers([feed], animated: false)
    }

    private func presentEdit(id: Int? = nil, text: String? = nil) {
        let edit = EditViewController(postID: id, text: text)
        edit.onPost = { [weak self] in
            self?.navController.popViewController(animated: true)
        }

        navController.pushViewController(edit, animated: true)
    }
}

