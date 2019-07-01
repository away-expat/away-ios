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
import Kingfisher
class UserProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChangeCitiesDelegate {
    
 
    let topView = UIView()
    let bottomView = UIView()
    var user: User?
    var profile: Profile?
    let userService = UserService()
    var joinedEvents: [Event] = []
    var createdEvents: [Event] = []
    let eventService = EventService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    var userId: Int?
    var isConnectedUser : Bool = true
    var eventsOfUserCellIdentifier = "eventsOfUserCellId"
    let emptyJoinedEventList : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aucun évènement à venir"
        return label
    }()
    let emptyCreatedEventList : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aucun évènement créé"
        return label
    }()
    let collectionViewCreateEvents: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let collectionViewJoinedEvent: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    override func viewWillAppear(_ animated: Bool) {
        let connectedUserId = Int(App.keychain!["userId"]!)
        if userId == connectedUserId || userId == nil {
            getConnectedUser()
            getUserCreatedEvents(userId: connectedUserId!)
            getUserJoinedEvents(userId: connectedUserId!)
            
        } else {
            isConnectedUser = false
            getUserById(userId: userId!)
            getUserCreatedEvents(userId: userId!)
            getUserJoinedEvents(userId: userId!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionViewCreateEvents {
            return createdEvents.count
        } else {
            return joinedEvents.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionViewCreateEvents {
            return 1
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewCreateEvents {
            return (CGSize(width: 180, height: 140))
        } else {
            return (CGSize(width: 180, height: 140))
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewCreateEvents {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventsOfUserCellIdentifier, for: indexPath) as! CustomCellEventUser
            cell.labelEventTitle.text = createdEvents[indexPath.row].title
            let urlAvatar = URL(string: (createdEvents[indexPath.row].photo))
            cell.cardImage.kf.setImage(with: urlAvatar)
            cell.labelEventDateTime.text = createdEvents[indexPath.row].date + " " + createdEvents[indexPath.row].hour
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventsOfUserCellIdentifier, for: indexPath) as! CustomCellEventUser
            cell.labelEventTitle.text = joinedEvents[indexPath.row].title
            let urlAvatar = URL(string: (joinedEvents[indexPath.row].photo))
            cell.cardImage.kf.setImage(with: urlAvatar)
            cell.labelEventDateTime.text = joinedEvents[indexPath.row].date + " " + joinedEvents[indexPath.row].hour
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < createdEvents.count {
            let eventDetailsController = EventDetailsController()
            eventDetailsController.eventId = createdEvents[indexPath.row].id
            self.navigationController?.pushViewController(eventDetailsController, animated: true)
        }
        if indexPath.row < joinedEvents.count {
            let eventDetailsController = EventDetailsController()
            eventDetailsController.eventId = joinedEvents[indexPath.row].id
            self.navigationController?.pushViewController(eventDetailsController, animated: true)
        }
    }
   
    

    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        //navigationItem.title = self.user?.at.name
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        collectionViewCreateEvents.dataSource = self
        collectionViewCreateEvents.delegate = self
        collectionViewJoinedEvent.dataSource = self
        collectionViewJoinedEvent.delegate = self
        collectionViewCreateEvents.register(CustomCellEventUser.self, forCellWithReuseIdentifier: eventsOfUserCellIdentifier)
        collectionViewJoinedEvent.register(CustomCellEventUser.self, forCellWithReuseIdentifier: eventsOfUserCellIdentifier)

        view.backgroundColor = .white
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
        
        
        let avatarImageView :UIImageView = {
            let avatarImageView = UIImageView()
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            avatarImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            avatarImageView.layer.cornerRadius = 50
            avatarImageView.clipsToBounds = true
            avatarImageView.layer.borderWidth = 3
            avatarImageView.layer.borderColor = UIColor.white.cgColor
            let url = URL(string: (isConnectedUser ? user?.avatar : profile?.avatar)!)
            avatarImageView.kf.setImage(with: url)
            return avatarImageView
        }()

        let userNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.text = isConnectedUser ? user!.firstname + " " + user!.lastname : profile!.firstname + " " + profile!.lastname
            
            return label
        }()
        
        let birthday: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = isConnectedUser ? user?.birth : profile?.birth
            return label
        }()
        let country: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = isConnectedUser ? user?.country : profile?.country
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
        let createdEventsListLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = "Vos évènements créés"
            return label
        }()
        let joinedEventsListLabel: UILabel = {
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
        userSettingsButton.isHidden = !isConnectedUser
        
        bottomView.addSubview(createdEventsListLabel)
        bottomView.addSubview(joinedEventsListLabel)

        bottomView.addSubview(collectionViewCreateEvents)
        bottomView.addSubview(collectionViewJoinedEvent)

        bottomView.addSubview(emptyJoinedEventList)
        bottomView.addSubview(emptyCreatedEventList)

        if !isConnectedUser {
            joinedEventsListLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20).isActive = true

        } else {
            joinedEventsListLabel.topAnchor.constraint(equalTo: userSettingsButton.bottomAnchor, constant: 20).isActive = true

        }
        joinedEventsListLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        createdEventsListLabel.topAnchor.constraint(equalTo: collectionViewJoinedEvent.bottomAnchor, constant: 15).isActive = true
        createdEventsListLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true


        collectionViewJoinedEvent.topAnchor.constraint(equalTo: joinedEventsListLabel.bottomAnchor).isActive = true
        collectionViewJoinedEvent.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        collectionViewJoinedEvent.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        collectionViewJoinedEvent.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        collectionViewCreateEvents.topAnchor.constraint(equalTo: createdEventsListLabel.bottomAnchor).isActive = true
        collectionViewCreateEvents.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        collectionViewCreateEvents.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        collectionViewCreateEvents.heightAnchor.constraint(equalToConstant: 150).isActive = true
        emptyCreatedEventList.centerXAnchor.constraint(equalTo: collectionViewCreateEvents.centerXAnchor).isActive = true
        emptyCreatedEventList.centerYAnchor.constraint(equalTo: collectionViewCreateEvents.centerYAnchor).isActive = true
        emptyJoinedEventList.centerXAnchor.constraint(equalTo: collectionViewJoinedEvent.centerXAnchor).isActive = true
        emptyJoinedEventList.centerYAnchor.constraint(equalTo: collectionViewJoinedEvent.centerYAnchor).isActive = true

    }
    @objc func userSettingsButtonClicked() {
        self.navigationController?.pushViewController(UserSettingsController(), animated: true)
    }
    @objc func tagButtonClicked() {
        
        let tagManagementController = TagManagementController()
        tagManagementController.isConnectedUser = isConnectedUser
        self.navigationController?.pushViewController(tagManagementController, animated: true)
    }
    
    func getUserCreatedEvents(userId : Int) {
        eventService.getUserCreatedEvents(token: token!, userId: userId, completion: { response, error in
            if error != nil {
                print ("user profile get created events error:", error!)
            } else {
                self.createdEvents = response
                DispatchQueue.main.async{
                    if self.createdEvents.isEmpty {
                        self.emptyCreatedEventList.isHidden = false
                        self.indicator.stopAnimating()
                    } else {
                        self.emptyCreatedEventList.isHidden = true
                    }
                    self.collectionViewCreateEvents.reloadData()
                    self.indicator.stopAnimating()

                }
            }

        })
    }
    func getUserJoinedEvents(userId : Int) {
        eventService.getUserEvents(token: token!, userId: userId, completion: { response, error in
            if error != nil {
                print ("user profile get joined events error:", error!)
            } else {
                self.joinedEvents = response
                DispatchQueue.main.async{
                    if self.joinedEvents.isEmpty {
                        self.emptyJoinedEventList.isHidden = false
                        self.indicator.stopAnimating()
                    } else {
                        self.emptyJoinedEventList.isHidden = true
                    }
                    self.collectionViewJoinedEvent.reloadData()
                    self.indicator.stopAnimating()

                }
            }

        })
    }
    func getUserById(userId: Int) {
        userService.getUserById(token: token!, userId: userId, completion: { response, error in
            if error != nil {
                print ("user profile get user by id error:", error!)
            } else {
                self.profile = response
                DispatchQueue.main.async{
                    self.setupViews()
                }
            }
            
        })
    }
    func getConnectedUser() {
        userService.getConnectedUser(token: token!, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller get user error:", error!)
            } else {
                self.user = response
                DispatchQueue.main.async{
                    self.setupViews()
                    //self.getUserEvents(userId: self.user!.id)

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


