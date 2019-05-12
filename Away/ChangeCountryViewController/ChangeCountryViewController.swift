//
//  ChangeCountryViewController.swift
//  Away
//
//  Created by Candice Guitton on 12/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class ChangeCountryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
 @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Country List"
        
        tableView.register(UINib(nibName: "CustomCountryCell", bundle: nil), forCellReuseIdentifier: "customCountryCell")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCountryCell", for: indexPath) as! CustomCountryCell
        let countryInLabel = ["France", "Japan", "England"]
        cell.customLabel.text = countryInLabel[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }

}
