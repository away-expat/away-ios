//
//  ListActivityByTag.swift
//  Away
//
//  Created by Candice Guitton on 11/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
class ListActivityByTagController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var activities: [Activity] = []
    let activityService = ActivityService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let tableView = UITableView()
    var tag : Tag = Tag(name: "bar")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Tokyo"
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(changeCity(_:)))
        
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
        let city = City(name: "Paris")
        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtYWlsIjoiYXplckBnbWFpbC5jb20iLCJwYXNzd29yZCI6ImF6ZXJ0eXVpb3AifQ.RfadKZR1WslusWcqQ5cuBvOs1eir7pAJnsUJ_0HnVBQ"
        
        activityService.getActivitiesByTag(token: token, city: city, tag: tag, completion :{ response , error in
            if error != nil {
                print ("listActivityByTag error:", error!)
            } else {
                self.activities = response
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
       
    }
    @objc func changeCity(_ sender: UIButton) {
        self.navigationController?.pushViewController(ChangeCitiesViewController(), animated: true)
        print("pays")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomActivityCell
        cell.label.text = activities[indexPath.row].name
        let url = URL(string: activities[indexPath.row].photos!)
        cell.cardImage.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //get event from activity you just clicked on
        print("selected cell \(indexPath.row)")
    }
}

