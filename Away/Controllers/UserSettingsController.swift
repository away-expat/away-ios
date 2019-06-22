//
//  UserSettingsController.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class UserSettingsController: UIViewController {
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = UILayoutConstraintAxis.vertical
        sv.distribution = .equalSpacing
        sv.spacing = 20
        return sv
    }()
    let firstname: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Firstname"
        return textfield
    }()
    let bottomFirstnameLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    let lastname: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Lastname"
        return textfield
    }()
    let bottomLastnameLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    let birthday: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Birthday"
        return textfield
    }()
    let bottomBirthdayLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    
    let logOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 15.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Déconnexion", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
        return button;
    }()
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .purple
        view.addSubview(stackView)
        view.addSubview(logOutButton)
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.addArrangedSubview(firstname)
        stackView.addArrangedSubview(bottomFirstnameLine)
        stackView.addArrangedSubview(lastname)
        stackView.addArrangedSubview(bottomLastnameLine)
        stackView.addArrangedSubview(birthday)
        stackView.addArrangedSubview(bottomBirthdayLine)


    }
    
    @objc func signOutButtonClicked() {
        try! App.keychain?.remove("token")
        UIApplication.setRootView(LoginViewController())
    }
    
    
}
