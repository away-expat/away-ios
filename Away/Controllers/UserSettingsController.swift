//
//  UserSettingsController.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class UserSettingsController: UIViewController, ChooseDateDelegate {
    var selectedDate: String?
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let stackViewFirstname: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let firstnameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Titre : "
        return label
    }()
    let firstnameTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    let stackViewLastname: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let lastnameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Titre : "
        return label
    }()
    let lastnameTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let stackViewEmail: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Titre : "
        return label
    }()
    let emailTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let stackViewPassword: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let passwordLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Titre : "
        return label
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    
    let stackViewCountry: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.distribution = .fillEqually
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let countryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Titre : "
        return label
    }()
    let countryTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    

    let stackViewDatePicker: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Date : "
        return label
    }()
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "de l'évènement"
        tf.addTarget(self, action: #selector(datePickerPopup(_:)), for: .allTouchEvents)
        return tf
    }()
    let updateUserButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 15.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Save", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(updateUserButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let logOutButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 15.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Déconnexion", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 15.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Suppression", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        button.addTarget(self, action: #selector(deleteAccountButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(stackView)
        stackView.addSubview(stackViewFirstname)
        stackViewFirstname.addSubview(firstnameLabel)
        stackViewFirstname.addSubview(firstnameTextField)
        
        stackView.addSubview(stackViewLastname)
        stackViewLastname.addSubview(lastnameLabel)
        stackViewLastname.addSubview(lastnameTextField)
        
        stackView.addSubview(stackViewEmail)
        stackViewEmail.addSubview(emailLabel)
        stackViewEmail.addSubview(emailTextField)
        
        stackView.addSubview(stackViewPassword)
        stackViewPassword.addSubview(passwordLabel)
        stackViewPassword.addSubview(passwordTextField)
        
        stackView.addSubview(stackViewDatePicker)
        stackViewDatePicker.addSubview(dateLabel)
        stackViewDatePicker.addSubview(dateTextField)
        
        
        stackView.addSubview(stackViewCountry)

        view.addSubview(logOutButton)
        view.addSubview(deleteButton)
        view.addSubview(updateUserButton)

        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: updateUserButton.topAnchor, constant: -3).isActive = true

        
        
        logOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    @objc func datePickerPopup(_ sender: UITextField) {
        let datePopupViewController = DatePopUpViewController()
        datePopupViewController.dateDelegate = self
        present(datePopupViewController, animated: true)
    }
    func saveDate(date: String) {
        dateTextField.text = date
    }
    
    @objc func updateUserButtonClicked() {
        //save user
    }
    
    
    @objc func signOutButtonClicked() {
        try! App.keychain?.remove("token")
        UIApplication.setRootView(LoginViewController())
    }
    
    @objc func deleteAccountButtonClicked() {
        //users/delete (DELETE) -> []
        UIApplication.setRootView(LoginViewController())

    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/mm/dd"
        
        selectedDate = dateFormatter.string(from: sender.date)
    }
    
    
}
