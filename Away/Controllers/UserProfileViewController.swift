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

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeCitiesDelegate {
 
    let topView = UIView()
    let bottomView = UIView()
    var user : User?
    let userService = UserService()
    var events: [Event] = []
    let eventService = EventService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let emptyEventList : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aucun évènement"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnectedUser()
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomEventListCell
        cell.titleEvent.text = events[indexPath.row].title
        cell.dateEvent.text = events[indexPath.row].date
        cell.timeEvent.text = events[indexPath.row].hour
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(EventDetailsController(), animated: true)
        print("selected cell \(indexPath.row)")
    }
    
    
    @objc func changeCities(_ sender: UIButton) {
        present(ChangeCitiesViewController(), animated: true)
        navigationItem.title = user?.at.name
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
        buildBottomView(bottomView: bottomView)
        setupConstraints()
    }
    
    func setupConstraints() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true

    }
    
    func buildTopView(topView: UIView) {
        let topViewStackView: UIStackView = {
            let sv = UIStackView()
            sv.axis = UILayoutConstraintAxis.horizontal
            sv.alignment = .center
            sv.translatesAutoresizingMaskIntoConstraints = false
            return sv
        }()
        
        let userInfosStackView: UIStackView = {
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
            label.text = user!.firstname + " " + user!.lastname
            return label
        }()
        
        let birthday: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = user?.birth
            return label
        }()
        let country: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = "France"
            return label
        }()
        let buttonView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return view
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
        
        
        topView.addSubview(topViewStackView)
        topViewStackView.addArrangedSubview(userInfosStackView)
        topViewStackView.addArrangedSubview(avatarImageView)
        userInfosStackView.addArrangedSubview(userNameLabel)
        userInfosStackView.addArrangedSubview(birthday)
        userInfosStackView.addArrangedSubview(country)
        userInfosStackView.addArrangedSubview(buttonView)
        buttonView.addSubview(tagButton)

        
        topViewStackView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        topViewStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        topViewStackView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -8).isActive = true
        topViewStackView.bottomAnchor.constraint(equalTo: topViewStackView.bottomAnchor).isActive = true

        userInfosStackView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        userInfosStackView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 8).isActive = true
        userInfosStackView.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        userInfosStackView.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        
        tagButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor).isActive = true
        tagButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor).isActive = true

        buttonView.leadingAnchor.constraint(equalTo: userInfosStackView.leadingAnchor).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: userInfosStackView.bottomAnchor).isActive = true
        buttonView.widthAnchor.constraint(equalTo:userInfosStackView.widthAnchor).isActive = true

    }
    func buildBottomView(bottomView: UIView){
        bottomView.backgroundColor = .white
        let eventsListLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = "Vos évènements à venir"
            return label
        }()
        
        let lineView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "AppPeach")
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
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
        bottomView.addSubview(lineView)
        bottomView.addSubview(userSettingsButton)
        lineView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 5).isActive = true
        lineView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5).isActive = true
        
        userSettingsButton.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10).isActive = true
        userSettingsButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 5).isActive = true
        userSettingsButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -5).isActive = true
        
        
        bottomView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        bottomView.addSubview(eventsListLabel)
        bottomView.addSubview(emptyEventList)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        eventsListLabel.topAnchor.constraint(equalTo: userSettingsButton.bottomAnchor, constant: 20).isActive = true
        eventsListLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(CustomEventListCell.self, forCellReuseIdentifier: "cellId")
        tableView.topAnchor.constraint(equalTo: eventsListLabel.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        tableView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15).isActive = true
        emptyEventList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyEventList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        eventService.getUserEvents(token: token!, completion: { response, error in
            if error != nil {
                print ("user profile get events error:", error!)
            } else {
                self.events = response
                DispatchQueue.main.async{
                    if self.events.isEmpty {
                        self.emptyEventList.isHidden = false
                        self.indicator.stopAnimating()
                    } else {
                        self.emptyEventList.isHidden = true
                    }
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()                }
            }
            
        })

    }
    @objc func userSettingsButtonClicked() {
        self.navigationController?.pushViewController(UserSettingsController(), animated: true)
    }
    @objc func tagButtonClicked() {
        self.navigationController?.pushViewController(TagManagementController(), animated: true)
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
