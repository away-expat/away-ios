//
//  TagManagementController.swift
//  Away
//
//  Created by Candice Guitton on 12/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess

class TagManagementController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(named: "AppLightGrey")
            textfield.attributedPlaceholder = NSAttributedString(string: "Rechercher un tag", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        }
        sb.layer.cornerRadius = 20
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        sb.backgroundImage = UIImage()
        return sb
    }()
    let layout: UICollectionViewFlowLayout = {
        let l =  UICollectionViewFlowLayout()
        l.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        l.itemSize = CGSize(width: 100, height: 80)
        return l
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    let tableView = UITableView()
    let emptyTagCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Choisissez 3 tags"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var searchActive : Bool = false
    var filtered:[Tag] = []
    let tagSearchCellIdentifier = "tagSearchCellId"
    
    var tagsOfUser : [Tag] = []
    let tagsOfUserCellIdentifier = "tagsOfUserCellId"
    
    let tagService = TagService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    var user : User?
    let userService = UserService()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getConnectedUser()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.register(CustomTagSearchCell.self, forCellReuseIdentifier: tagSearchCellIdentifier)
        collectionView.register(CustomTagsOfUserCell.self, forCellWithReuseIdentifier: tagsOfUserCellIdentifier)
        collectionView.backgroundColor = .white
        
    }
    func getConnectedUser() {
        userService.getConnectedUser(token: token!, completion: { response , error in
            if error != nil {
                print ("Tag management get user error:", error!)
            } else {
                DispatchQueue.main.async{
                    self.user = response
                    self.setupViews()
                }
                
            }
            
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            collectionView.isHidden = true
            tagService.getTags(token: token!, search: searchText, completion: { response , error in
                if error != nil {
                    print ("add/remove tag error:", error!)
                } else {
                    self.filtered = response
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
                
            })
        } else {
            filtered = []
            self.tableView.reloadData()

        }
       
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tagSearchCellIdentifier) as! CustomTagSearchCell;
            cell.textLabel?.text = filtered[indexPath.row].name
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
            getTagNameInSearchBar(tag: filtered[indexPath.row])
            tagService.likeTag(token: token!, id: filtered[indexPath.row].id, completion: { response , error in
                if error != nil {
                    print ("like tag error:", error!)
                } else {
                    self.tagsOfUser.append(response!)
                    DispatchQueue.main.async{
                        self.filtered = []
                        self.tableView.reloadData()
                        self.tableView.isHidden = true
                        self.collectionView.isHidden = false
                        self.collectionView.reloadData()
                    }
                }
                
            })
    }
    func getTagNameInSearchBar(tag: Tag) {
        searchBar.text = tag.name
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsOfUser.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagsOfUserCellIdentifier, for: indexPath) as! CustomTagsOfUserCell
        cell.label.text = tagsOfUser[indexPath.row].name
        return cell
    }
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.addSubview(collectionView)
        view.addSubview(emptyTagCollectionView)
        
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       
        
        emptyTagCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyTagCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        tagService.getTagsOfUser(token: token!, completion: { response , error in
            if error != nil {
                print ("get tag of user error:", error!)
            } else {
                self.tagsOfUser = response
                DispatchQueue.main.async{
                    if self.tagsOfUser.isEmpty {
                        self.emptyTagCollectionView.isHidden = false
                    } else {
                        self.emptyTagCollectionView.isHidden = true
                    }
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
        
    }
}

