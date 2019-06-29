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
    var selectedDate: String?
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = UILayoutConstraintAxis.vertical
        sv.sizeToFit()
        sv.alignment = .center
        sv.spacing = 20
        return sv
    }()
    let emailTextField: UITextField = {
        let email = UITextField()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Email"
        return email
    }()
    let bottomEmailLine: UIView = {
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
    
    let firstNameTextField: UITextField = {
        let firstname = UITextField()
        firstname.translatesAutoresizingMaskIntoConstraints = false
        firstname.placeholder = "Firstname"
        return firstname
    }()
    let bottomFirstnameLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    let lastNameTextField: UITextField = {
        let lastname = UITextField()
        lastname.translatesAutoresizingMaskIntoConstraints = false
        lastname.placeholder = "Lastname"
        return lastname
    }()
    let bottomLastnameLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    
    let birthday: UITextField = {
        let birth = UITextField()
        birth.translatesAutoresizingMaskIntoConstraints = false
        birth.placeholder = "YY-MM-DD"
        return birth
    }()
//    let datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = UIDatePicker.Mode.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-mm-dd"
//        let selectedDate = dateFormatter.string(from: datePicker.date)
//        datePicker.timeZone = NSTimeZone.local
//        datePicker.backgroundColor = .white
//        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
//        return datePicker
//    }()
    let bottomBirthdayLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "AppPeach")
        return line
    }()
    let countryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Choose country"
        textField.textAlignment = .center
        return textField
    }()
    let bottomCountryLine: UIView = {
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
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(bottomEmailLine)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(bottomPasswordLine)
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(bottomFirstnameLine)
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(bottomLastnameLine)
        stackView.addArrangedSubview(birthday)
        stackView.addArrangedSubview(bottomBirthdayLine)
        view.addSubview(logOutButton)
        
//        bottomEmailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        bottomEmailLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        bottomPasswordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        bottomPasswordLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        bottomFirstnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        bottomFirstnameLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//        bottomLastnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        bottomLastnameLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//
//
//        bottomCountryLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        bottomCountryLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 5).isActive = true

    }
    
    @objc func signOutButtonClicked() {
        try! App.keychain?.remove("token")
        UIApplication.setRootView(LoginViewController())
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/mm/dd"
        
        selectedDate = dateFormatter.string(from: sender.date)
    }
    
    
}
