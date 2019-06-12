//
//  SubscribeLauncher.swift
//  Away
//
//  Created by Candice Guitton on 24/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class SubscribeLauncherController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = UILayoutConstraintAxis.vertical
        sv.distribution = .equalSpacing
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
    let countryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Choose country"
        return textField
    }()
    let countries = ["Japan","France","USA"]
    let countryPickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.backgroundColor = UIColor(named: "AppLightGrey")
        countryTextField.inputAccessoryView = toolBar
    }
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AppPeach")
        button.layer.cornerRadius = 4.0
        button.layer.shadowOpacity = 1.0
        button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        return button;
    }()
    
    
    
    
    let goBackButton: UIButton = {
        let image = UIImage(named: "delete-button")
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(goBackSignIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func dismissPickerView() {
        if let view = UIApplication.shared.keyWindow {
            view.endEditing(true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = countries[row]
        countryTextField.text = selectedCountry
    }
    
    

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(bottomEmailLine)
        
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(bottomPasswordLine)
        
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(bottomFirstnameLine)
        
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(bottomLastnameLine)
        
        stackView.addArrangedSubview(countryTextField)
        stackView.addArrangedSubview(signUpButton)
        createToolBar()
        countryPickerView.delegate = self
        countryTextField.inputView = countryPickerView
        
        view.addSubview(goBackButton)
        goBackButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomEmailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomEmailLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomPasswordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPasswordLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomFirstnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomFirstnameLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomLastnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLastnameLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        signUpButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        }
       

    @objc func signUpButtonClicked() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
        let user = User(firstname: firstNameTextField.text!, lastname: lastNameTextField.text!, country: countryTextField.text!)

        
        
        let tabBar = TabBar();
        tabBar.createTabBar();

    }
    
    @objc func goBackSignIn() {
        self.navigationController?.popViewController(animated: true)        
        dismiss(animated: true, completion: nil)
    }
    
}
