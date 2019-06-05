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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "Japan"
        navigationItem.title = "Japan"
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        navigationItem.title = "Japan"
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(getInfos(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        topView.backgroundColor = .white
        bottomView.backgroundColor = UIColor(named: "AppLightGrey")
        buildTopView(topView: topView)
        setupConstraints()
        
    }
    @objc func getInfos(_ sender: UIButton) {
        //self.navigationController?.pushViewController(HomeViewController(), animated: true)
        print("infos")
    }
    func setupConstraints() {
       let topTopView = NSLayoutConstraint(item: topView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let leadingTopView = NSLayoutConstraint(item: topView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let heightTopView = NSLayoutConstraint(item: topView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: view.bounds.height/4)
        let widthTopView = NSLayoutConstraint(item: topView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: view.bounds.width)
            topView.translatesAutoresizingMaskIntoConstraints = false
        
        let topBottomView = NSLayoutConstraint(item: bottomView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadingBottomView = NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let bottomBottomView = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let widthBottomView = NSLayoutConstraint(item: bottomView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: view.bounds.width)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([topTopView, leadingTopView, heightTopView, widthTopView, topBottomView, leadingBottomView, bottomBottomView, widthBottomView])
    }
    
    func buildTopView(topView: UIView) {
        let topViewStackView: UIStackView = {
            let sv = UIStackView()
            sv.axis = UILayoutConstraintAxis.horizontal
            sv.alignment = .center
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        
        let userNameDescriptionStackView: UIStackView = {
            let sv = UIStackView()
            sv.axis = UILayoutConstraintAxis.vertical
            sv.alignment = .leading
            sv.distribution = .fillProportionally
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        
        let avatar = UIImage(named: "bird")
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.image = avatar
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        
        let userNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.text = "Candice Guitton"
            return label
        }()
        
        let descriptionLabel: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont.boldSystemFont(ofSize: 14)
            textView.text = "je suis contente de faire de l'ios omg cest trop bien "
            textView.isEditable = false
            return textView
        }()
        let buttonView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return view
        }()
        let tagManagementButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "AppPeach")
            button.layer.cornerRadius = 15.0
            button.layer.shadowOpacity = 1.0
            button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
            button.setTitle("Modifier le profil", for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.addTarget(self, action: #selector(tagManagementButtonClicked), for: .touchUpInside)
            return button;
        }()
        
        topView.addSubview(topViewStackView)
        topViewStackView.addArrangedSubview(userNameDescriptionStackView)
        topViewStackView.addArrangedSubview(avatarImageView)
        userNameDescriptionStackView.addArrangedSubview(userNameLabel)
        userNameDescriptionStackView.addArrangedSubview(descriptionLabel)
        userNameDescriptionStackView.addArrangedSubview(buttonView)
        buttonView.addSubview(tagManagementButton)
        
        descriptionLabel.widthAnchor.constraint(equalTo: userNameDescriptionStackView.widthAnchor).isActive = true
        descriptionLabel.delegate = self
        descriptionLabel.isScrollEnabled = false
        topViewStackView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        topViewStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        topViewStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        topViewStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true

        userNameDescriptionStackView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        userNameDescriptionStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        userNameDescriptionStackView.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        userNameDescriptionStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        
        buttonView.leadingAnchor.constraint(equalTo: userNameDescriptionStackView.leadingAnchor).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: userNameDescriptionStackView.bottomAnchor).isActive = true
        buttonView.widthAnchor.constraint(equalTo:userNameDescriptionStackView.widthAnchor).isActive = true

    }
    @objc func tagManagementButtonClicked() {
        print("damn")
    }
}

extension UserProfileViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach {(constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
            
        }
    }
}
