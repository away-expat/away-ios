//
//  ChangeCountryViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class ChangeCitiesViewController: UIViewController, UISearchBarDelegate {
    
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
    }
    
    func setupViews() {
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
  
    }
}

