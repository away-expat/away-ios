//
//  TabBar.swift
//  Away
//
//  Created by Candice Guitton on 11/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class TabBar: NSObject {
    
    var firstTabNavigationController : UINavigationController!
    var secondTabNavigationController : UINavigationController!
    var thirdTabNavigationController : UINavigationController!
    var fourthTabNavigationController : UINavigationController!
    var fifthTabNavigationController : UINavigationController!

    let tabBarController = UITabBarController()
    
    func createTabBar() {
        let appDelegate = UIApplication.shared.delegate
        
        tabBarController.delegate = self
        
        firstTabNavigationController = UINavigationController.init(rootViewController: HomeViewController())
        secondTabNavigationController = UINavigationController.init(rootViewController: TagScreenViewController())
        thirdTabNavigationController = UINavigationController.init(rootViewController: AddActivityViewController())
        fourthTabNavigationController = UINavigationController.init(rootViewController: ChangeCountryViewController())
        fifthTabNavigationController = UINavigationController.init(rootViewController: UserProfileViewController())
        
        tabBarController.viewControllers = [firstTabNavigationController, secondTabNavigationController, thirdTabNavigationController, fourthTabNavigationController, fifthTabNavigationController]
        
        let item1 = UITabBarItem(title: "Home", image: UIImage(named: "home"), tag: 0)
        let item2 = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 1)
        let item3 = UITabBarItem(title: "Add", image: UIImage(named: "add"), tag: 2)
        let item4 = UITabBarItem(title: "Countries", image: UIImage(named: "earth"), tag: 3)
        let item5 = UITabBarItem(title: "Profile", image: UIImage(named: "user"), tag: 4)
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationController.tabBarItem = item2
        thirdTabNavigationController.tabBarItem = item3
        fourthTabNavigationController.tabBarItem = item4
        fifthTabNavigationController.tabBarItem = item5
        
        UITabBar.appearance().tintColor = .orange
        UITabBar.appearance().backgroundColor = .white
        
        appDelegate?.window??.rootViewController = tabBarController
        appDelegate?.window??.makeKeyAndVisible()
    }
    
}

extension TabBar : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController else {
            return
        }
        
        navigationController.popToRootViewController(animated: false)
    }
}
