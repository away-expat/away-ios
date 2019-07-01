//
//  HomeViewController.swift
//  Away
//
//  Created by Candice Guitton on 16/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
import Kingfisher

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeCitiesDelegate {
    var user : User?
    let userService = UserService()
    var events: [Event] = []
    let activityService = ActivityService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView()
    
    private let refreshControl = UIRefreshControl()

    let cityLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let emptyEventList : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aucun évènement"
        return label
    }()
    
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let userId = App.keychain!["userId"]
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnectedUser()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomHomeEventCell
        cell.labelActivityTitle.text = events[indexPath.row].activityName
        cell.labelEventDateTime.text = events[indexPath.row].date + "  " + events[indexPath.row].hour
        cell.labelEventTitle.text = events[indexPath.row].title
        let url = URL(string: events[indexPath.row].photo)
        cell.cardImage.kf.setImage(with: url)
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
    
    
    func getConnectedUser() {
        userService.getConnectedUser(token: token!, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller get user error:", error!)
            } else {
                self.user = response
                DispatchQueue.main.async{
                    try! App.keychain?.set(self.user!.id.description, key: "userId")
                    self.setupViews()
                }
            }
            
        })
    }
    
    func onCitiesChanged(city: City) {
        navigationItem.title = city.name
        changeUserCity(cityId: city.id)
    }
    @objc func chooseCityToVisitButtonClicked() {
        let changeCitiesViewController = ChangeCitiesViewController()
        changeCitiesViewController.cityDelegate = self
        present(changeCitiesViewController, animated: true)
    }
    func setupViews() {
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.title = user?.at.name
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.addSubview(emptyEventList)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        emptyEventList.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyEventList.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyEventList.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(CustomHomeEventCell.self, forCellReuseIdentifier: "cellId")
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.startAnimating()
        indicator.hidesWhenStopped = true

        refreshControl.addTarget(self, action: #selector(refreshEventSuggestion), for: .valueChanged)
        getEventSuggestions()
        
    }
    
    @objc func refreshEventSuggestion() {
        self.emptyEventList.isHidden = true
        activityService.getSuggestions(token: token!, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller error:", error!)
            } else {
                self.events = response
                DispatchQueue.main.async{
                    self.indicator.stopAnimating()
                    if self.events.isEmpty {
                        self.emptyEventList.isHidden = false
                    } else {
                        self.emptyEventList.isHidden = true
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()

                }
            }
            
        })
    }
    
    func getEventSuggestions() {
        activityService.getSuggestions(token: token!, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller error:", error!)
            } else {
                self.events = response
                DispatchQueue.main.async{
                    self.indicator.stopAnimating()
                    
                    if self.events.isEmpty {
                        self.emptyEventList.isHidden = false
                    } else {
                        self.emptyEventList.isHidden = true
                    }
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    func changeUserCity(cityId: Int) {
        userService.updateUserCity(token: token!, cityId: cityId, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller change city error:", error!)
            } else {
                self.user?.at = response!
                DispatchQueue.main.async{
                    self.indicator.stopAnimating()
                    self.getEventSuggestions()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
}
