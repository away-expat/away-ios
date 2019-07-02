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
    var user: User?
    let userService = UserService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]

    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.backgroundColor = .yellow
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let stackViewFirstname: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let firstnameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Prénom : "
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
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let lastnameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nom : "
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
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let emailLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email : "
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
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let passwordLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password : "
    
        return label
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let stackViewCountry: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let countryLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pays d'origine : "
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
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "Date de naissance : "
        return label
    }()
    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
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
        button.setTitle("Sauvegarder", for: .normal)
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
        button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
        return button
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Suppression", for: .normal)
        button.addTarget(self, action: #selector(deleteAccountButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        view.addSubview(stackView)
        stackView.addArrangedSubview(stackViewFirstname)
        stackViewFirstname.addArrangedSubview(firstnameLabel)
        stackViewFirstname.addArrangedSubview(firstnameTextField)
        
        stackView.addArrangedSubview(stackViewLastname)
        stackViewLastname.addArrangedSubview(lastnameLabel)
        stackViewLastname.addArrangedSubview(lastnameTextField)
        
        stackView.addArrangedSubview(stackViewEmail)
        stackViewEmail.addArrangedSubview(emailLabel)
        stackViewEmail.addArrangedSubview(emailTextField)
        
        stackView.addArrangedSubview(stackViewPassword)
        stackViewPassword.addArrangedSubview(passwordLabel)
        stackViewPassword.addArrangedSubview(passwordTextField)
        
        stackView.addArrangedSubview(stackViewDatePicker)
        stackViewDatePicker.addArrangedSubview(dateLabel)
        stackViewDatePicker.addArrangedSubview(dateTextField)
        
        
        stackView.addArrangedSubview(stackViewCountry)
        stackViewCountry.addArrangedSubview(countryLabel)
        stackViewCountry.addArrangedSubview(countryTextField)
        
        view.addSubview(updateUserButton)
        view.addSubview(logOutButton)
        view.addSubview(deleteButton)

        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant : 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant : 8).isActive = true

        updateUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        updateUserButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant : 80).isActive = true
        updateUserButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        updateUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        deleteButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        deleteButton.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant : 10).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true


        logOutButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        logOutButton.topAnchor.constraint(equalTo: updateUserButton.bottomAnchor, constant : 10).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        setupViews()
    }
    
    func setupViews() {
        firstnameTextField.text = user?.firstname
        lastnameTextField.text = user?.lastname
        emailTextField.text = user?.mail
        dateTextField.text = user?.birth
        countryTextField.text = user?.country
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
        userService.updateUser(token: token!, firstname: firstnameTextField.text!, lastname: lastnameTextField.text!, mail: emailTextField.text!, password: passwordTextField.text!, birth: dateTextField.text!, country: countryTextField.text!, completion: { response, error in
            if error != nil {
                print ("save usererror:", error!)
            } else {
            }
            
        })
        
    }
    
    
    @objc func signOutButtonClicked() {
        try! App.keychain?.remove("token")
        UIApplication.setRootView(LoginViewController())
    }
    
    @objc func deleteAccountButtonClicked() {
        userService.deleteAccount(token: token!, completion: { response, error in
            if error != nil {
                print ("delete usererror:", error!)
            } else {
                DispatchQueue.main.async {
                    UIApplication.setRootView(LoginViewController())
                }
            }
            
        })

    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        selectedDate = dateFormatter.string(from: sender.date)
    }
    
    
}
