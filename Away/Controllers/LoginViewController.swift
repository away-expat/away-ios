//
//  LoginViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
class LoginViewController: UIViewController, UITextFieldDelegate {
    var loginService = LoginService()
    
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
        
        password.backgroundColor = UIColor(named: "AppLightGrey")
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
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        logoImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true

        loginTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginTextField.widthAnchor.constraint(equalTo: loginStackView.widthAnchor).isActive = true
        loginTextField.textAlignment = .center
        passwordTextField.textAlignment = .center
        bottomLoginLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLoginLine.widthAnchor.constraint(equalTo: loginStackView.widthAnchor).isActive = true
        
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: loginStackView.widthAnchor).isActive = true
        
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    @objc func loginButtonClicked() {
        loginService.signIn{ response , error in
            if error != nil {
                print ("login error:", error!)
            } else {
                try! App.keychain?.set(response, key: "token")
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
                let tabBar = TabBar();
                tabBar.createTabBar();
            }
            
        }
        
    }
    
    @objc func signUpButtonClicked(_ sender: UIButton) {
        present(SubscribeLauncherController(), animated: true, completion: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        KeyboardUtils.WillChange(notification: notification, view: view)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("Return pressed")
        KeyboardUtils.hide(textField: textField)
        return true
    }
    

}
