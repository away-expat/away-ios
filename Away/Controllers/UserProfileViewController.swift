//
//  UserProfileViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class UserProfileViewController: UIViewController {
    let topView = UIView()
    let bottomView = UIView()
    let userTextField = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Japan"
        let infoIcon = UIImage(named: "info")
        let infoImageView = UIImageView()
        infoImageView.image = infoIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        navigationItem.title = "Japan"
        let button = UIBarButtonItem(image: infoImageView.image, style: .plain, target: self, action: #selector(getInfos(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        topView.backgroundColor = .white
        topView.addSubview(userTextField)
        userTextField.adjustsFontForContentSizeCategory = true
        userTextField.leadingAnchor.constraint(equalTo: topView.leadingAnchor)

        bottomView.backgroundColor = UIColor(named: "AppLightGrey")
        
        let avatar = UIImage(named: "bird")
        let avatarImageView = UIImageView(frame: CGRect(x: view.bounds.width-100-10, y: 10, width: 100, height: 100))
        avatarImageView.layer.cornerRadius = (avatarImageView.frame.width/2)
        avatarImageView.image = avatar
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        topView.addSubview(avatarImageView)

        
        setupConstraints()
        
    }
    @objc func getInfos(_ sender: UIButton) {
        //self.navigationController?.pushViewController(HomeViewController(), animated: true)
        print("infos")
    }
    func setupConstraints() {
       let topTopView = NSLayoutConstraint(item: topView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingTopView = NSLayoutConstraint(item: topView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let heightTopView = NSLayoutConstraint(item: topView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: view.bounds.height/3)
        let widthTopView = NSLayoutConstraint(item: topView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: view.bounds.width)
            topView.translatesAutoresizingMaskIntoConstraints = false
        
        let topBottomView = NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadingBottomView = NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let bottomBottomView = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let widthBottomView = NSLayoutConstraint(item: bottomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: view.bounds.width)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([topTopView, leadingTopView, heightTopView, widthTopView, topBottomView, leadingBottomView, bottomBottomView, widthBottomView])
    }
}
