//
//  SubscribeLauncher.swift
//  Away
//
//  Created by Candice Guitton on 24/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class SubscribeLauncherController: UIViewController, UITextFieldDelegate, ChangeCitiesDelegate, ChooseDateDelegate {
   
    var selectedDate: String?
    let loginService = LoginService()
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
        password.isSecureTextEntry = true
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


    let dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Date de naissance :"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(datePickerPopup(_:)), for: .allTouchEvents)
        return tf
    }()
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
   
    let chooseCityToVisitButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(named: "AppLightGrey")
        btn.layer.borderColor = UIColor(named: "AppPeach")?.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4.0
        btn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        btn.setTitle("City you want to visit", for: .normal)
        btn.setTitleColor(UIColor(named: "AppPeach"), for: .normal)
        btn.addTarget(self, action: #selector(chooseCityToVisitButtonClicked), for: .touchUpInside)
        return btn;
    }()
    
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
    var city: City?

    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        
        return v
    }()
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(bottomEmailLine)
        
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(bottomPasswordLine)
        
        stackView.addArrangedSubview(firstNameTextField)
        stackView.addArrangedSubview(bottomFirstnameLine)
        
        stackView.addArrangedSubview(lastNameTextField)
        stackView.addArrangedSubview(bottomLastnameLine)
        
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(bottomBirthdayLine)
        
        stackView.addArrangedSubview(countryTextField)
        stackView.addArrangedSubview(bottomCountryLine)
        stackView.addArrangedSubview(chooseCityToVisitButton)


        stackView.addArrangedSubview(signUpButton)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        countryTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        scrollView.addSubview(goBackButton)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
        goBackButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40).isActive = true
        goBackButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        stackView.bottomAnchor.constraint(equalTo: goBackButton.topAnchor, constant: -30).isActive = true
        
        bottomEmailLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomEmailLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomPasswordLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomPasswordLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomFirstnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomFirstnameLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomLastnameLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLastnameLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomBirthdayLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomBirthdayLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        bottomCountryLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomCountryLine.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        signUpButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    @objc func datePickerPopup(_ sender: UITextField) {
        let datePopupViewController = DatePopUpViewController()
        datePopupViewController.dateDelegate = self
        present(datePopupViewController, animated: true)
    }
    func saveDate(date: String) {
        dateTextField.text = date
    }
    func onCitiesChanged(city: City) {
        self.city = city
        chooseCityToVisitButton.setTitle(city.name, for: .normal)
    }
    @objc func chooseCityToVisitButtonClicked() {
        let changeCitiesViewController = ChangeCitiesViewController()
        changeCitiesViewController.cityDelegate = self
        present(changeCitiesViewController, animated: true)
    }
    
    @objc func signUpButtonClicked() {
        
        if firstNameTextField.text == nil{
            print("phoque1")
        }
        if lastNameTextField.text == nil{
            print("phoque2")
        }
        if emailTextField.text == nil{
            print("phoque3")
        }
        if passwordTextField.text == nil{
            print("phoque4")
        }
        if dateTextField.text == nil
        {
            print("phoque5")
        }
        if countryTextField.text == nil {
            print("phoque6")
        }
        if city?.id == nil {
            print("phoque7")
        }
        loginService.signUp(firstname: firstNameTextField.text!, lastname: lastNameTextField.text!, mail: emailTextField.text!, password: passwordTextField.text!, birth: dateTextField.text!, country: countryTextField.text!, idCity: city!.id, completion: { response , error in
            if error != nil {
                print ("login error:", error!)
            } else {
                try! App.keychain?.set(response, key: "token")
                DispatchQueue.main.async{
                    let tagManagementController = TagManagementController()
                    tagManagementController.isSubscriberController = true
                    self.present(tagManagementController, animated: true)
                }
            }
            
        })
        self.navigationController?.dismiss(animated: false, completion: nil)

    }
    
    @objc func goBackSignIn() {
        self.navigationController?.popViewController(animated: true)        
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillChange(notification: Notification) {
        KeyboardUtils.WillChange(notification: notification, view: scrollView)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("Return pressed sign up")
        KeyboardUtils.hide(textField: textField)
        return true
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/mm/dd"
        
        selectedDate = dateFormatter.string(from: sender.date)
    }
    
}
