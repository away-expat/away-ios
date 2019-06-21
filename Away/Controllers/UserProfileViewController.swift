//
//  UserProfileViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class UserProfileViewController: UIViewController, ChangeCitiesDelegate {
 
    let topView = UIView()
    let bottomView = UIView()
    var user : User?
    let userService = UserService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnectedUser()
    
    }
    @objc func changeCities(_ sender: UIButton) {
        present(ChangeCitiesViewController(), animated: true)
        navigationItem.title = user?.at.name
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
        
        let birthday: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont.boldSystemFont(ofSize: 14)
            textView.text = "15/08/1992"
            textView.isEditable = false
            return textView
        }()
        let country: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.font = UIFont.boldSystemFont(ofSize: 14)
            textView.text = "France"
            textView.isEditable = false
            return textView
        }()
        let buttonView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return view
        }()
        let userSettingsButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "AppPeach")
            button.layer.cornerRadius = 15.0
            button.layer.shadowOpacity = 1.0
            button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
            button.setTitle("Modifier le profil", for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.addTarget(self, action: #selector(userSettingsButtonClicked), for: .touchUpInside)
            return button;
        }()
        let tagButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "AppPeach")
            button.layer.cornerRadius = 15.0
            button.layer.shadowOpacity = 1.0
            button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
            button.setTitle("Tags", for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.addTarget(self, action: #selector(tagButtonClicked), for: .touchUpInside)
            return button;
        }()
        
        let logOutButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "AppPeach")
            button.layer.cornerRadius = 15.0
            button.layer.shadowOpacity = 1.0
            button.layer.shadowColor = UIColor(named: "AppLightGrey")?.cgColor
            button.setTitle("Deco", for: .normal)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
            return button;
        }()
        topView.addSubview(topViewStackView)
        topViewStackView.addArrangedSubview(userNameDescriptionStackView)
        topViewStackView.addArrangedSubview(avatarImageView)
        userNameDescriptionStackView.addArrangedSubview(userNameLabel)
        userNameDescriptionStackView.addArrangedSubview(birthday)
        userNameDescriptionStackView.addArrangedSubview(country)
        userNameDescriptionStackView.addArrangedSubview(buttonView)
        buttonView.addSubview(userSettingsButton)
        buttonView.addSubview(tagButton)
        buttonView.addSubview(logOutButton)
        birthday.widthAnchor.constraint(equalTo: userNameDescriptionStackView.widthAnchor).isActive = true
        
        
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
        tagButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true

    }
    @objc func userSettingsButtonClicked() {
        self.navigationController?.pushViewController(UserSettingsController(), animated: true)
    }
    @objc func tagButtonClicked() {
        self.navigationController?.pushViewController(TagManagementController(), animated: true)
    }
    @objc func signOutButtonClicked() {
        try! App.keychain?.remove("token")
      UIApplication.setRootView(LoginViewController())
    }
    
    func getConnectedUser() {
        userService.getConnectedUser(token: token!, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller get user error:", error!)
            } else {
                self.user = response
                DispatchQueue.main.async{
                    self.setupViews()
                }
            }
            
        })
    }
    func onCitiesChanged(city: City) {
        navigationItem.title = city.name
        self.user!.at = city
    }
    @objc func chooseCityToVisitButtonClicked() {
        let changeCitiesViewController = ChangeCitiesViewController()
        changeCitiesViewController.cityDelegate = self
        present(changeCitiesViewController, animated: true)
    }
    
    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = self.user?.at.name
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(changeCities(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        topView.backgroundColor = .white
        bottomView.backgroundColor = UIColor(named: "AppLightGrey")
        buildTopView(topView: topView)
        setupConstraints()
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
