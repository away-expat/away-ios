//
//  HomeViewController.swift
//  Away
//
//  Created by Candice Guitton on 16/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeCitiesDelegate {
    
    
    var user : User?
    let userService = UserService()
    var events: [Event] = []
    let activityService = ActivityService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView()
    let cityLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnectedUser()
        
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomActivityCell
        cell.label.text = events[indexPath.row].activityName
        return cell
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.pushViewController(EventDetailsController(), animated: true)
        print("selected cell \(indexPath.row)")
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
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(CustomActivityCell.self, forCellReuseIdentifier: "cellId")
        
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
        
        
        activityService.getSuggestions(token: token!, completion: { response , error in
            if error != nil {
                print ("homeviewcontroller error:", error!)
            } else {
                self.events = response
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
    }
}
