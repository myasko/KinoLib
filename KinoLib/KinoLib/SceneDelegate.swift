//
//  SceneDelegate.swift
//  KinoLib
//
//  Created by Yaroslav Fomenko on 25.10.2021.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
    
        let window = UIWindow(windowScene: scene)
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .dark
        }
        
        let rootVC: UIViewController!
        if Auth.auth().currentUser == nil {
            rootVC = AuthViewController()
        } else {
            rootVC = MainViewController()
        }
        
        UITabBar.appearance().tintColor = Colors.highlight
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.highlight], for: .normal)
        
        let tabBar = UITabBarController()
        let navMain = UINavigationController(rootViewController: rootVC)
        navMain.navigationBar.tintColor = Colors.highlight
        
        let iconMain = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        navMain.tabBarItem = iconMain
        
        let searchVC = SearchViewController()
        let navSearch = UINavigationController(rootViewController: searchVC)
        let iconSearch = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        navSearch.tabBarItem = iconSearch
        
        let profileVC = ProfileViewController()
        let navProfile = UINavigationController(rootViewController: profileVC)
        let iconProfile = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        navProfile.tabBarItem = iconProfile
        
        tabBar.viewControllers = [navMain, navSearch, navProfile]
        
        self.window = window
        window.makeKeyAndVisible()
        window.rootViewController = tabBar
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

