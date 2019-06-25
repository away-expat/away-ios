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
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()

    let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 0.0)
    
    let tableView = UITableView()
    let emptyTagCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Choisissez 3 tags"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var filtered:[Tag] = []
    let tagSearchCellIdentifier = "tagSearchCellId"
    var isSubscriberController: Bool = false
    var tagsOfUser : [Tag] = []
    let tagsOfUserCellIdentifier = "tagsOfUserCellId"
    
    let tagService = TagService()
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
            self.tableView.isHidden = false
            tagService.getTags(token: token!, search: searchText, completion: { response , error in
                if error != nil {
                    print ("add/remove tag error:", error!)
                } else {
                    self.filtered = response
                    DispatchQueue.main.async{
                        self.emptyTagCollectionView.isHidden = true
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
        return filtered.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tagSearchCellIdentifier) as! CustomTagSearchCell;
            cell.textLabel?.text = filtered[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        searchBar.text = ""
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
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        validateTag()
    }
    func validateTag() {
        self.navigationController?.pushViewController(HomeViewController(), animated: true)
        let tabBar = TabBar()
        tabBar.createTabBar()
    }
    func getTagNameInSearchBar(tag: Tag) {
        searchBar.text = tag.name
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsOfUser.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return (CGSize(width: 100, height: 40))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagsOfUserCellIdentifier, for: indexPath) as! CustomTagsOfUserCell
        cell.label.text = tagsOfUser[indexPath.row].name
        cell.dislikeButton.tag =  tagsOfUser[indexPath.row].id
        cell.dislikeButton.addTarget(self, action: #selector(triggerAlert(_:)), for: .touchUpInside)
        return cell
    }
    func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.addSubview(collectionView)
        view.addSubview(emptyTagCollectionView)
        if isSubscriberController {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            searchBar.setValue("Valider", forKey: "cancelButtonText")
            searchBar.setShowsCancelButton(true, animated: true)

        } else {
            searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        if tagsOfUser.isEmpty {
            emptyTagCollectionView.isHidden = false
        }

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
    @objc func triggerAlert(_ sender: UIButton) {
        let tagId = sender.tag
        let alert = UIAlertController(title: "Etes vous sur de vouloir supprimer ce tag?", message: "Vous pourrez l'ajouter de nouveau plus tard", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.dislikeTag(tag: tagId)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func dislikeTag(tag: Int) {
        tagService.dislikeTag(token: token!, id: tag, completion: { success , error in
            if !success {
                print ("dislike tag error:", error!)
            } else {
                let index = self.tagsOfUser.index(where: { (item) -> Bool in
                    item.id == tag
                })
                self.tagsOfUser.remove(at: index!)
                DispatchQueue.main.async{
                    if self.tagsOfUser.isEmpty {
                        self.emptyTagCollectionView.isHidden = false
                    }
                    self.tableView.reloadData()
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                }
            }
            
        })
    }
    
}

