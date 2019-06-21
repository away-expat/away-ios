//
//  AppDelegate.swift
//  Away
//
//  Created by Candice Guitton on 14/02/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess

typealias App = AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var keychain: Keychain?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        App.keychain = Keychain(server: Bundle.main.bundleIdentifier!, protocolType: .https)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(named: "AppPeach")

        if App.keychain!["token"] != nil {
            // Show home page
            let navigationController = UINavigationController(rootViewController:HomeViewController())
            self.window?.rootViewController = navigationController
            navigationController.isNavigationBarHidden = true
            let tabBar = TabBar();
            tabBar.createTabBar();
            
        } else {
            let loginViewController = LoginViewController()
            self.window?.rootViewController = loginViewController
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension UIApplication {
    public static func setRootView(_ viewController: UIViewController) {
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
}

