//
//  TabBar.swift
//  Away
//
//  Created by Candice Guitton on 11/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UITabBar {
    
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
        thirdTabNavigationController = UINavigationController.init(rootViewController: CreateEventViewController())
        fourthTabNavigationController = UINavigationController.init(rootViewController: ConvenientInformationController())
        fifthTabNavigationController = UINavigationController.init(rootViewController: UserProfileViewController())
        
        tabBarController.viewControllers = [firstTabNavigationController, secondTabNavigationController, thirdTabNavigationController, fourthTabNavigationController, fifthTabNavigationController]
        
        let item1 = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
        let item2 = UITabBarItem(title: nil, image: UIImage(named: "search"), tag: 1)
        let item3 = UITabBarItem(title: nil, image: UIImage(named: "add"), tag: 2)
        let item4 = UITabBarItem(title: nil, image: UIImage(named: "info"), tag: 3)
        let item5 = UITabBarItem(title: nil, image: UIImage(named: "user"), tag: 4)
        
        item1.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item4.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item5.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationController.tabBarItem = item2
        thirdTabNavigationController.tabBarItem = item3
        fourthTabNavigationController.tabBarItem = item4
        fifthTabNavigationController.tabBarItem = item5
       
        self.tabBarController.tabBar.shadowImage = UIImage()
        self.tabBarController.tabBar.backgroundImage = UIImage()
        self.tabBarController.tabBar.clipsToBounds = true
        
        UITabBar.appearance().tintColor = UIColor(named: "AppOrange")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "AppLightOrange")
        UITabBar.appearance().backgroundColor = UIColor(named: "AppPeach")
    
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
