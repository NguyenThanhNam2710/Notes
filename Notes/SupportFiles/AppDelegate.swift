//
//  AppDelegate.swift
//  Notes
//
//  Created by Nam Nguyễn Thành on 31/07/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.config()
        return true
    }
    
    func config() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navi = UINavigationController()
        navi.modalPresentationStyle = .fullScreen
        let mainView = UIStoryboard.instantiate(name: "Note", NoteViewController.self)
        navi.viewControllers = [mainView]
        self.window!.rootViewController = navi
        self.window?.makeKeyAndVisible()
    }
    
}

