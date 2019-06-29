//
//  EventDetailsController.swift
//  Away
//
//  Created by Candice Guitton on 11/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
import Kingfisher

class EventDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeCitiesDelegate {
   
    
    var event: EventDetailsResponse?
    var eventId: Int?
    let eventService = EventService()
    var user: User?
    var participants: [UserList] = []
    let userService = UserService()
    let bottomView = UIView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let tableViewLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Participant(s) :"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let tableView = UITableView()
    let emptyEventList : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aucun participant"
        return label
    }()
    
    let eventTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let eventDescription: UITextView = {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 250, height: 100))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 18.0)
        return textView
    }()
    let activityImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let imageActivityLink: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "location-icon")
        iv.image = image?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        iv.clipsToBounds = true
        return iv
    }()
    let activityLocationLink: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor(named: "AppOrange"), for: .normal)
        btn.addTarget(self, action: #selector(urlActivity), for: .touchUpInside)
        return btn
    }()
    let avatar : UIImageView = {
        let avatarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        return avatarImageView
    }()
    
    let creatorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16.0)
        return label
    }()
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16.0)
        return label
    }()
    
    let joinEvent: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("Rejoindre", for: .normal)
        btn.addTarget(self, action: #selector(joinEventButton), for: .touchUpInside)
        return btn
    }()
    let eventInfosStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = UILayoutConstraintAxis.vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let placementAvatarStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = UILayoutConstraintAxis.horizontal
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getEventDetails()
        
        
    }
    
    func setupViews() {
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        view.addSubview(activityImage)
        view.addSubview(eventInfosStackView)
        eventInfosStackView.addArrangedSubview(eventTitle)
        eventInfosStackView.addArrangedSubview(placementAvatarStackView)
        placementAvatarStackView.addArrangedSubview(eventDescription)
        placementAvatarStackView.addArrangedSubview(avatar)
        eventInfosStackView.addArrangedSubview(creatorLabel)
        view.addSubview(imageActivityLink)
        view.addSubview(activityLocationLink)
        view.addSubview(dateTimeLabel)
        view.addSubview(tableViewLabel)
        view.addSubview(tableView)
        view.addSubview(joinEvent)
        let url = URL(string: (event!.activity.photos!))
        activityImage.kf.setImage(with: url)
        
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(TabSearchCustomUserCell.self, forCellReuseIdentifier: "cellId")
        
        eventTitle.text = event?.event.title
        eventDescription.text = event?.event.description
        let urlAvatar = URL(string: (event!.creator.avatar))
        avatar.kf.setImage(with: urlAvatar)
        creatorLabel.text = (event?.creator.firstname)! + " " + (event?.creator.lastname)!
        activityLocationLink.setTitle(event?.activity.name, for: .normal)
        dateTimeLabel.text = (event?.event.date)! + " " + (event?.event.hour)!
//        eventTitle.topAnchor.constraint(equalTo: activityImage.bottomAnchor, constant: 15).isActive = true
//        eventTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
//        eventDescription.topAnchor.constraint(equalTo: eventTitle.bottomAnchor, constant: 10).isActive = true
//        eventDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        
        activityImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        activityImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        eventInfosStackView.topAnchor.constraint(equalTo: activityImage.bottomAnchor).isActive = true
        eventInfosStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        eventInfosStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //eventDescription.leadingAnchor.constraint(equalTo: placementAvatarStackView.leadingAnchor, constant: 5).isActive = true
        //avatar.trailingAnchor.constraint(equalTo: placementAvatarStackView.trailingAnchor).isActive = true
        creatorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageActivityLink.topAnchor.constraint(equalTo: eventInfosStackView.bottomAnchor, constant: 7).isActive = true
        imageActivityLink.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageActivityLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageActivityLink.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        activityLocationLink.topAnchor.constraint(equalTo: eventInfosStackView.bottomAnchor, constant: 7).isActive = true
        activityLocationLink.leadingAnchor.constraint(equalTo: imageActivityLink.trailingAnchor, constant: 5).isActive = true
        //activityLocationLink.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        activityLocationLink.heightAnchor.constraint(equalToConstant: 20).isActive = true

        dateTimeLabel.topAnchor.constraint(equalTo: imageActivityLink.bottomAnchor, constant: 4).isActive = true
        dateTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tableViewLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 10).isActive = true
        tableViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        tableView.topAnchor.constraint(equalTo: tableViewLabel.bottomAnchor, constant: 15).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        joinEvent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        joinEvent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        joinEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TabSearchCustomUserCell
        cell.username.text = participants[indexPath.row].firstname + " " + participants[indexPath.row].lastname
        let url = URL(string: participants[indexPath.row].avatar)
        cell.avatarImageView.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userProfileViewController = UserProfileViewController()
        userProfileViewController.userId = participants[indexPath.row].id
        self.navigationController?.pushViewController(userProfileViewController, animated: true)
        print("selected cell \(indexPath.row)")
    }
    @objc func urlActivity() {
        let activityDetailsController = ActivityDetailsController()
        activityDetailsController.activity = event?.activity
        self.navigationController?.pushViewController(activityDetailsController, animated: true)
    }
    @objc func joinEventButton() {
        print("hello beauty")
    }
    func getEventDetails() {
        eventService.getEventDetails(token: token!, eventId: eventId!, completion: { response , error in
            if error != nil {
                print ("get events details error:", error!)
            } else {
                self.event = response
                self.participants = response!.participant
                DispatchQueue.main.async{
                    if self.event == nil {
                        self.emptyEventList .isHidden = false
                    } else {
                        self.emptyEventList.isHidden = true
                        self.tableView.isHidden = false
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
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
