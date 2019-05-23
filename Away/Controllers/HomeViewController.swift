//
//  HomeViewController.swift
//  Away
//
//  Created by Candice Guitton on 16/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
     override func viewDidLoad() {
        super.viewDidLoad()
        let infoIcon = UIImage(named: "info")
        let infoImageView = UIImageView()
        infoImageView.image = infoIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        navigationItem.title = "Japan"
        let button = UIBarButtonItem(image: infoImageView.image, style: .plain, target: self, action: #selector(getInfos(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.register(CustomActivityCell.self, forCellReuseIdentifier: "cellId")
       // tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
    }
    @objc func getInfos(_ sender: UIButton) {
        //self.navigationController?.pushViewController(HomeViewController(), animated: true)
        print("infos")
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! CustomActivityCell
        let messageArray = ["Restaurants", "Musées", "Bars"]
        cell.label.text = messageArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
}

class Header: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let viewHeader: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    func setupViews() {
       // contentView.addSubview(viewHeader)
//        viewHeader.addSubview(nameLabel)
//        viewHeader.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        viewHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        viewHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        viewHeader.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
}
