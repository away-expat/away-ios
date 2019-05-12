//
//  HomeViewController.swift
//  Away
//
//  Created by Candice Guitton on 11/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "ActivityList"
        
        tableView.register(UINib(nibName: "CustomActivityCell", bundle: nil), forCellReuseIdentifier: "customActivityCell")
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customActivityCell", for: indexPath) as! CustomActivityCell
        let messageArray = ["First", "Second", "Third"]
        cell.customLabel.text = messageArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    
}
