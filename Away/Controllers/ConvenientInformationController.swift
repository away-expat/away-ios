//
//  ConvenientInformationController.swift
//  Away
//
//  Created by Candice Guitton on 03/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class ConvenientInformationController: UIViewController, ChangeCitiesDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
                let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        view.backgroundColor = .white

    }
    func onCitiesChanged(city: City) {
        navigationItem.title = city.name
    }
    @objc func chooseCityToVisitButtonClicked() {
        let changeCitiesViewController = ChangeCitiesViewController()
        changeCitiesViewController.cityDelegate = self
        present(changeCitiesViewController, animated: true)
    }
}
