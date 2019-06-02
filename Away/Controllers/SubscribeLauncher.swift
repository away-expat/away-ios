//
//  SubscribeLauncher.swift
//  Away
//
//  Created by Candice Guitton on 24/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class SubscribeLauncher: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
   
    
    
    
    let whiteView = UIView()
    
    let redView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    
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
    
    
    @objc func showSignUp() {
        
        if let view = UIApplication.shared.keyWindow {
            
            whiteView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            whiteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            view.addSubview(whiteView)
            view.addSubview(redView)
            
            let height: CGFloat = view.frame.height - 50
            let y = view.frame.height - height
            redView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
            redView.addSubview(stackView)
            stackView.frame = redView.frame
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
            
            
            stackView.centerXAnchor.constraint(equalTo: redView.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: redView.centerYAnchor).isActive = true
            stackView.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
            
            bottomEmailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            bottomEmailLine.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
            
            bottomPasswordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            bottomPasswordLine.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
            
            bottomFirstnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            bottomFirstnameLine.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
            
            bottomLastnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            bottomLastnameLine.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
            
            signUpButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
            signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

            
            whiteView.frame = view.frame
            whiteView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.whiteView.alpha = 1
                self.redView.frame = CGRect(x: 0, y: y, width: self.redView.frame.width, height: self.redView.frame.height)
                
            }, completion: nil)
            
    
            //        self.navigationController?.pushViewController(SignUpController(), animated: true)
            //        let tabBar = TabBar()
            //        tabBar.createTabBar()
        }
       
    }
        @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteView.alpha = 0
            if let view = UIApplication.shared.keyWindow {
                self.redView.frame = CGRect(x: 0, y: view.frame.height, width: self.redView.frame.width, height: self.redView.frame.height)
            }
        })
    }

    @objc func signUpButtonClicked(_ sender: UIButton) {
        
    }
       override init() {
        super.init()
    }
    
    
}
