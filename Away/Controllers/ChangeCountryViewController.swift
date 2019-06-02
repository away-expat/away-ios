//
//  ChangeCountryViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class ChangeCountryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let messageArray = ["Paris", "Tokyo", "London"]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Japan"
        let infoIcon = UIImage(named: "info")
        let infoImageView = UIImageView()
        infoImageView.image = infoIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        navigationItem.title = "Japan"
        let button = UIBarButtonItem(image: infoImageView.image, style: .plain, target: self, action: #selector(getInfos(_:)))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 100, height: 80)
        
        let countryCollectionView:UICollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self
        
        let searchBar = UISearchBar(frame:CGRect(x:0, y:0, width: Int(UIScreen.main.bounds.width), height: 40))
        view.addSubview(searchBar)
        searchBar.backgroundColor = .blue
        
        countryCollectionView.backgroundColor = .white
        
        countryCollectionView.register(CustomCountryCell.self, forCellWithReuseIdentifier: "cellId")
        
        view.addSubview(countryCollectionView)
        countryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        countryCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        countryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        countryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        countryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true


        
    }
    
    
    @objc func getInfos(_ sender: UIButton) {
        //self.navigationController?.pushViewController(HomeViewController(), animated: true)
        print("infos")
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CustomCountryCell
            cell.label.text = messageArray[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (CGSize(width: view.bounds.width, height: 44))
    }
    
   
}

