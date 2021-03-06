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
    let userId = App.keychain!["userId"]
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
        textView.isEditable = false
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
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        return avatarImageView
    }()
    
    let creatorLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.black, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16.0)
        button.addTarget(self, action: #selector(presentCreator), for: .touchUpInside)
        return button
    }()
    let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16.0)
        return label
    }()
    
    let joinEvent: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(named: "AppPeach")
        btn.layer.cornerRadius = 15.0
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 18.0)
        btn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(toggleParticipation), for: .touchUpInside)
        return btn
    }()
    let eventInfosStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = UILayoutConstraintAxis.vertical
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let creatorStackView: UIStackView = {
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
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        getEventDetails()
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    func setupViews() {
        view.addSubview(activityImage)
        view.addSubview(eventInfosStackView)
        eventInfosStackView.addArrangedSubview(eventTitle)
        eventInfosStackView.addArrangedSubview(placementAvatarStackView)
        placementAvatarStackView.addArrangedSubview(eventDescription)
        placementAvatarStackView.addArrangedSubview(creatorStackView)
        creatorStackView.addArrangedSubview(avatar)
        creatorStackView.addArrangedSubview(creatorLabel)
        view.addSubview(imageActivityLink)
        view.addSubview(activityLocationLink)
        view.addSubview(dateTimeLabel)
        view.addSubview(joinEvent)
        view.addSubview(tableViewLabel)
        view.addSubview(tableView)
        let url = URL(string: (event!.activity.photos!))
        activityImage.kf.setImage(with: url)
        //view.addSubview(indicator)
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.widthAnchor.constraint(equalToConstant: 100).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(TabSearchCustomUserCell.self, forCellReuseIdentifier: "cellId")
        tableView.backgroundColor = .white
        eventTitle.text = event?.event.title
        eventDescription.text = event?.event.description
        let urlAvatar = URL(string: (event!.creator.avatar))
        avatar.kf.setImage(with: urlAvatar)
        creatorLabel.setTitle((event?.creator.firstname)! + " " + (event?.creator.lastname)!, for: .normal)
        activityLocationLink.setTitle(event?.activity.name, for: .normal)
        dateTimeLabel.text = (event?.event.date)! + " " + (event?.event.hour)!

        activityImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        activityImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        eventInfosStackView.topAnchor.constraint(equalTo: activityImage.bottomAnchor, constant: 10).isActive = true
        eventInfosStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        eventInfosStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        imageActivityLink.topAnchor.constraint(equalTo: eventInfosStackView.bottomAnchor, constant: 7).isActive = true
        imageActivityLink.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageActivityLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageActivityLink.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        activityLocationLink.topAnchor.constraint(equalTo: eventInfosStackView.bottomAnchor, constant: 7).isActive = true
        activityLocationLink.leadingAnchor.constraint(equalTo: imageActivityLink.trailingAnchor, constant: 5).isActive = true
        activityLocationLink.heightAnchor.constraint(equalToConstant: 20).isActive = true

        dateTimeLabel.topAnchor.constraint(equalTo: imageActivityLink.bottomAnchor, constant: 4).isActive = true
        dateTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tableViewLabel.topAnchor.constraint(equalTo: dateTimeLabel.bottomAnchor, constant: 10).isActive = true
        tableViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        tableView.topAnchor.constraint(equalTo: tableViewLabel.bottomAnchor, constant: 15).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        joinEvent.topAnchor.constraint(equalTo: imageActivityLink.bottomAnchor, constant: 4).isActive = true
        joinEvent.leadingAnchor.constraint(equalTo: dateTimeLabel.trailingAnchor).isActive = true
        joinEvent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        joinEvent.bottomAnchor.constraint(equalTo: tableViewLabel.topAnchor, constant: -5).isActive = true

        if participants.contains(where: {$0.id == Int(userId!)}) {
            joinEvent.setTitle("Quitter", for: .normal)
        } else {
            joinEvent.setTitle("Rejoindre", for: .normal)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TabSearchCustomUserCell
        cell.username.text = participants[indexPath.row].firstname + " " + participants[indexPath.row].lastname
        let url = URL(string: participants[indexPath.row].avatar)
        cell.avatarImageView.kf.setImage(with: url)
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(named: "AppPeach")
        separatorView.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 1.0,  width:cell.contentView.frame.size.width, height: 1)
        cell.contentView.addSubview(separatorView)
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
    @objc func presentCreator() {
        let userProfileViewController = UserProfileViewController()
        userProfileViewController.userId = event?.creator.id
        self.navigationController?.pushViewController(userProfileViewController, animated: true)
    }
    @objc func toggleParticipation() {
        if participants.contains(where: {$0.id == Int(userId!)}) {
            leave()
        }else{
            participate()
        }
    }
    func participate() {
        eventService.postParticipateAtEvent(token: token!, eventId: eventId!, completion: { response , error in
            if error != nil {
                print ("join events error:", error!)
            } else {
                DispatchQueue.main.async{
                    self.getEventDetails()
                }
            }
            
        })
    }
    func leave() {
        eventService.leaveEvent(token: token!, eventId: eventId!, completion: { response , error in
            if error != nil {
                print ("leave events error:", error!)
            } else {
                DispatchQueue.main.async{
                    self.getEventDetails()
                }
            }
            
        })
    }
    func getEventDetails() {
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
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
