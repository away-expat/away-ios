//
//  LoginViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    let loginTextField: UITextField = {
        let login = UITextField();
        login.translatesAutoresizingMaskIntoConstraints = false
        login.backgroundColor = .white
        login.textColor = UIColor(named: "AppLightGrey")
        login.heightAnchor.constraint(equalToConstant: 40)
        login.layer.cornerRadius = 6.0
        login.layer.borderColor = UIColor(named: "AppOrange")?.cgColor
        login.layer.borderWidth = 3.0
        return login
    }()
    
    let passwordTextField: UITextField = {
        let password = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30));
        password.translatesAutoresizingMaskIntoConstraints = false
        
        return password
    }()
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = .blue
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        loginButton.frame = CGRect(x: 150, y: 150, width: 100, height: 50)
        
        return loginButton;
    }()
    
    let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
        view.addSubview(loginStackView)
        view.backgroundColor = UIColor(named: "AppPeach")
        loginStackView.backgroundColor = .white
        loginTextField.center = view.center
        loginTextField.placeholder = "Place holder text"
        loginTextField.borderStyle = UITextBorderStyle.line
        loginTextField.backgroundColor = UIColor.white
        loginTextField.textColor = UIColor.blue
        
        passwordTextField.center = view.center
        passwordTextField.placeholder = "Place holder text"
        passwordTextField.borderStyle = UITextBorderStyle.line
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.textColor = UIColor.blue
        
        loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    
        loginStackView.addArrangedSubview(loginTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)


    }
    @objc func loginButtonClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
        let tabBar = TabBar()
        tabBar.createTabBar()
        
        print(loginTextField.text)
        print(passwordTextField.text)
        
    }
    
}

