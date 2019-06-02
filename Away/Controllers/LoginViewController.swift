//
//  LoginViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false

        logo.image = UIImage(named: "logo")
        return logo
    }()
    let loginTextField: UITextField = {
        let login = UITextField()
        login.translatesAutoresizingMaskIntoConstraints = false
        login.backgroundColor = UIColor(named: "AppLightGrey")
        login.placeholder = "Login"
        return login
    }()
    let bottomLoginLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    let passwordTextField: UITextField = {
        let password = UITextField()
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = "Password"
        return password
    }()
    
    let bottomPasswordLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    
    let loginButton: UIButton = {
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = UIColor(named: "AppPeach")
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.shadowOpacity = 1.0
        loginButton.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return loginButton;
    }()
    
    let signUpButton: UIButton = {
        let signUp = UIButton()
        signUp.translatesAutoresizingMaskIntoConstraints = false
        signUp.setTitle("Sign Up", for: .normal)
        signUp.setTitleColor(UIColor(named: "AppOrange"), for: .normal)
        signUp.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        return signUp;
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
        view.backgroundColor = .white
        
        let safeAreaView = UIView(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width, height: 20))
        safeAreaView.backgroundColor = UIColor(named: "AppPeach")
        view.addSubview(safeAreaView)
        
        loginStackView.addArrangedSubview(logoImageView)
        loginStackView.addArrangedSubview(loginTextField)
        loginStackView.addArrangedSubview(bottomLoginLine)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(bottomPasswordLine)
        
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true

        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginTextField.widthAnchor.constraint(equalTo: loginStackView.widthAnchor).isActive = true
        
        bottomLoginLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLoginLine.widthAnchor.constraint(equalTo: loginStackView.widthAnchor).isActive = true
        
        bottomPasswordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPasswordLine.widthAnchor.constraint(equalTo: loginStackView.widthAnchor).isActive = true
        
        loginStackView.addArrangedSubview(loginButton)

        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        loginStackView.addArrangedSubview(signUpButton)

        loginStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginStackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    @objc func loginButtonClicked() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
        let tabBar = TabBar()
        tabBar.createTabBar()
        
        
    }
    let subscribeLauncher = SubscribeLauncher()
    @objc func signUpButtonClicked(_ sender: UIButton) {
        subscribeLauncher.showSignUp()
    }
   
}

