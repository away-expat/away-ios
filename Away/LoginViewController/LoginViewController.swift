//
//  LoginViewController.swift
//  Away
//
//  Created by Candice Guitton on 11/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }


    @IBAction func HomeButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
        let tabBar = TabBar()

        tabBar.createTabBar()
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
