//
//  ActivityDetailsController.swift
//  Away
//
//  Created by Candice Guitton on 23/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class ActivityDetailsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Japan"
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(changeCities(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
        
    }
    @objc func changeCities(_ sender: UIButton) {
        self.navigationController?.pushViewController(ChangeCitiesViewController(), animated: true)
        print("pays")
    }
}
