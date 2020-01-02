//
//  AppDelegate.swift
//  ManageIssue
//
//  Created by Taof on 10/14/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

@UIApplicationMain
@available(iOS 13.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var sharedApp = UIApplication.shared.delegate as? AppDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *){
            
        }else{
            window = UIWindow(frame: UIScreen.main.bounds)
            let token = UserDefaults.standard.string(forKey: "token") ?? ""
            
            if token.isEmpty {
                startLogIn()
            }else{
                startMain()
            }
        }
        return true
    }
    
    func startLogIn(){
        let loginVC = LoginViewController()
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }
    
    func startMain(){
        let homeVC = HomeViewController()
        let slideVC = SlideMenuViewController()
        let navigation = UINavigationController(rootViewController: homeVC)
        navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        let slideMenuController = SlideMenuController(mainViewController: navigation, leftMenuViewController: slideVC)
        SlideMenuOptions.contentViewScale = 1
        window?.rootViewController = slideMenuController
        window?.makeKeyAndVisible()
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

