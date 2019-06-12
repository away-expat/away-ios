//
//  ChangeCountryViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class ChangeCitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let messageArray = ["Paris", "Tokyo", "London"]
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    let layout: UICollectionViewFlowLayout = {
       let l =  UICollectionViewFlowLayout()
        l.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        l.itemSize = CGSize(width: 100, height: 80)
        return l
    }()
    
    func setupNavigationBar() {
        navigationItem.title = "Japan"
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Japan"
    }
    
    func setupViews() {
        let countryCollectionView:UICollectionView = {
            let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.backgroundColor = .white
            cv.register(CustomCountryCell.self, forCellWithReuseIdentifier: "cellId")
            return cv
        }()
        countryCollectionView.dataSource = self
        countryCollectionView.delegate = self
        view.addSubview(searchBar)
        view.addSubview(countryCollectionView)

        
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        countryCollectionView.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 10).isActive = true
        countryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        countryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        countryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        countryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
       
        
        
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

