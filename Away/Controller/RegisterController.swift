//
//  RegisterController.swift
//  Away
//
//  Created by Candice Guitton on 01/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit

class RegisterController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
    }
    
}

