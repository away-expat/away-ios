//
//  ListActivityByTag.swift
//  Away
//
//  Created by Candice Guitton on 11/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import Kingfisher
import KeychainAccess

class ListActivityByTagController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var activities: [Activity] = []
    let activityService = ActivityService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView()
    var tag : Tag?
    var user : User?
    let userService = UserService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let customActivityCellIdentifier = "activityCellId"
    var loadMoreToken: String?
    let emptyCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Pas de résultat"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomActivityCell.self, forCellReuseIdentifier: customActivityCellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        getConnectedUser()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customActivityCellIdentifier, for: indexPath) as! CustomActivityCell
        if indexPath.row < activities.count {
            cell.labelActivityTitle.text = activities[indexPath.row].name
            let url = URL(string: activities[indexPath.row].photos!)
            cell.cardImage.kf.setImage(with: url)
            if indexPath.row == activities.count - 1 {
                loadMore()
            }
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < activities.count {
            let activityDetailsController = ActivityDetailsController()
            activityDetailsController.activity = activities[indexPath.row]
            self.navigationController?.pushViewController(activityDetailsController, animated: true)
            
        }
        print("selected cell \(indexPath.row)")
    }

    func getConnectedUser() {
        userService.getConnectedUser(token: token!, completion: { response , error in
            if error != nil {
                print ("listTag get user error:", error!)
            } else {
                self.user = response
                DispatchQueue.main.async{
                    self.setupViews()
                }
            }

        })
    }
    
    func setupViews() {
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        indicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        activityService.getActivitiesByTag(token: token!, city: user!.at, tag: tag!.name, completion :{ response, loadMoreToken, error in
            if error != nil {
                print ("listActivityByTag error:", error!)
            } else {
                self.activities = response
                self.loadMoreToken = loadMoreToken
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
        
    }

    func loadMore() {
        activityService.loadMore(token: token!, loadMoreToken: loadMoreToken!,  completion: { response, loadMoreToken, error in
            if error != nil {
                print ("load more error:", error!)
            } else {
                self.activities += response
                self.loadMoreToken = loadMoreToken
                print("Nb loadmore response = ", response.count)
                DispatchQueue.main.async{
                    if self.activities.isEmpty {
                        self.emptyCollectionView.isHidden = false
                    } else {
                        self.emptyCollectionView.isHidden = true
                        self.tableView.isHidden = false
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
}

