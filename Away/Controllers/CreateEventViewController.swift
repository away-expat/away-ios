//
//  AddActivityViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController: UIViewController {
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Event"
        view.backgroundColor = .white
        
    }
   
}
