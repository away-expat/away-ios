//
//  TagScreenViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class TagScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, ChangeCitiesDelegate {
    var tags: [Tag] = []
    let tagService = TagService()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var user : User?
    let userService = UserService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let searchTagView: UIView = {
       let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Rechercher"
        return sb
    }()

    let tagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let tagCellIdentifier = "tagCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConnectedUser()
        
        
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
    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        view.addSubview(searchTagView)
        view.addSubview(tagCollectionView)
        view.addSubview(indicator)
        
        searchTagView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchTagView.bottomAnchor.constraint(equalTo: tagCollectionView.topAnchor).isActive = true
        searchTagView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchTagView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchTagView.heightAnchor.constraint(equalToConstant: view.bounds.height/3).isActive = true
        searchTagView.addSubview(searchBar)
        
        searchBar.delegate = self
        
        searchBar.topAnchor.constraint(equalTo: searchTagView.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: searchTagView.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: searchTagView.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        tagCollectionView.backgroundColor = .white
        
        tagCollectionView.register(CustomTagCell.self, forCellWithReuseIdentifier: tagCellIdentifier)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        tagCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tagCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
        tagService.getTag{ response , error in
            if error != nil {
                print ("tagscreencontroller error:", error!)
            } else {
                self.tags = response
                
                DispatchQueue.main.async{
                    self.tagCollectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        }
    }
    func onCitiesChanged(city: City) {
        navigationItem.title = city.name
    }
    @objc func chooseCityToVisitButtonClicked() {
        let changeCitiesViewController = ChangeCitiesViewController()
        changeCitiesViewController.cityDelegate = self
        present(changeCitiesViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellIdentifier, for: indexPath) as! CustomTagCell
        cell.label.text = tags[indexPath.row].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (CGSize(width: 160, height: 120))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ListActivityByTagController(), animated: true)
    }
    
}
