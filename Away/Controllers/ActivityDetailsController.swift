//
//  ActivityDetailsController.swift
//  Away
//
//  Created by Candice Guitton on 23/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
import Kingfisher
class ActivityDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChangeCitiesDelegate {

    
    var tags: [String]?
    var activity: Activity?
    let activityService = ActivityService()
    var events: [EventItem] = []
    let eventService = EventService()
    var user: User?
    let userService = UserService()
    let bottomView = UIView()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    let tableView = UITableView()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let tagsOfActivityCellIdentifier = "tagOfActivityCellId"
    let emptyEventList : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aucun évènement"
        return label
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let sectionInsets = UIEdgeInsets(top: 3.0, left: 5.0, bottom: 3.0, right: 0.0)
    
    let activityTitle: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
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
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(urlActivity), for: .allTouchEvents)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    @objc func urlActivity(sender: UITapGestureRecognizer) {
        let url = activity?.url
        let targetURL = NSURL(string: url!)
        let application = UIApplication.shared
        application.open(targetURL! as URL, completionHandler: nil)
    }
//    func getConnectedUser() {
//        userService.getConnectedUser(token: token!, completion: { response , error in
//            if error != nil {
//                print ("activityDetails get user error:", error!)
//            } else {
//                self.user = response
//                DispatchQueue.main.async{
//                    self.setupViews()
//                }
//            }
//
//        })
//    }
    func setupViews() {
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(activityTitle)
        activityTitle.text = activity?.name
        view.addSubview(activityImage)
        let url = URL(string: (activity?.photos)!)
        activityImage.kf.setImage(with: url)
        view.addSubview(imageActivityLink)
        view.addSubview(activityLocationLink)
        activityLocationLink.setTitle(activity?.address, for: .normal)
        tags = activity?.type
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomTagsOfActivityCell.self, forCellWithReuseIdentifier: tagsOfActivityCellIdentifier)
        collectionView.backgroundColor = .white
        view.addSubview(bottomView)
        buildBottomView(bottomView: bottomView)

        activityTitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        activityTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        activityTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true

        activityImage.topAnchor.constraint(equalTo: activityTitle.bottomAnchor).isActive = true
        activityImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        activityImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        activityImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        imageActivityLink.topAnchor.constraint(equalTo: activityImage.bottomAnchor, constant: 7).isActive = true
        imageActivityLink.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        imageActivityLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageActivityLink.widthAnchor.constraint(equalToConstant: 20).isActive = true

        activityLocationLink.topAnchor.constraint(equalTo: activityImage.bottomAnchor, constant: 7).isActive = true
        activityLocationLink.leadingAnchor.constraint(equalTo: imageActivityLink.trailingAnchor, constant: 5).isActive = true
        activityLocationLink.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        activityLocationLink.heightAnchor.constraint(equalToConstant: 20).isActive = true

        collectionView.topAnchor.constraint(equalTo: activityLocationLink.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (CGSize(width: 100, height: 40))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagsOfActivityCellIdentifier, for: indexPath) as! CustomTagsOfActivityCell
        cell.label.text = tags?[indexPath.row]
        return cell
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
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailsController = EventDetailsController()
        eventDetailsController.eventId = events[indexPath.row].id
        self.navigationController?.pushViewController(eventDetailsController, animated: true)
        print("selected cell \(indexPath.row)")
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
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        bottomView.addSubview(eventsListLabel)
        bottomView.addSubview(emptyEventList)
        bottomView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        eventsListLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20).isActive = true
        eventsListLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(CustomEventListCell.self, forCellReuseIdentifier: "cellId")
        tableView.topAnchor.constraint(equalTo: eventsListLabel.bottomAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        tableView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -15).isActive = true
        
        emptyEventList.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyEventList.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
//        tableView.addSubview(indicator)
//        indicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
//        indicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
//        indicator.startAnimating()
//        indicator.hidesWhenStopped = true
        eventService.getEventsByActivity(token: token!, activityId: (activity?.id)!, completion: { response, error in
            if error != nil {
                print ("get events by activity error:", error!)
            } else {
                self.events = response
                DispatchQueue.main.async{
                    if self.events.isEmpty {
                        self.emptyEventList.isHidden = false
                        self.tableView.isHidden = true
                        self.indicator.stopAnimating()
                    } else {
                        self.emptyEventList.isHidden = true
                        self.tableView.isHidden = false

                    }
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    
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



