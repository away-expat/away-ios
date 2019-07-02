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
            textfield.returnKeyType = .done
            textfield.resignFirstResponder() // hides the keyboard.

        }
        sb.layer.cornerRadius = 20
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        sb.backgroundImage = UIImage()
        return sb
    }()
    let collectionViewV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let collectionViewH: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 0.0)
    let sectionInsetsSuggestion = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

    let tableView = UITableView()
    let emptyTagCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Choisissez 3 tags"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let suggestionTagCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Suggestion de tags"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let userTagsCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Tags"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var filtered:[Tag] = []
    let tagSearchCellIdentifier = "tagSearchCellId"
    var isSubscriberController: Bool = false
    var tagsOfUser : [Tag] = []
    var tagsSuggestions: [Tag] = []
    let tagsOfUserCellIdentifier = "tagsOfUserCellId"
    let tagsSuggestionCellIdentifier = "tagsSuggestionCellId"
    let tagService = TagService()
    let token = App.keychain!["token"]
    var user : User?
    let userService = UserService()
    var isConnectedUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getConnectedUser()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        collectionViewH.dataSource = self
        collectionViewH.delegate = self
        collectionViewV.dataSource = self
        collectionViewV.delegate = self
        tableView.register(CustomTagSearchCell.self, forCellReuseIdentifier: tagSearchCellIdentifier)
        collectionViewV.register(CustomTagsOfUserCell.self, forCellWithReuseIdentifier: tagsOfUserCellIdentifier)
        collectionViewH.register(TagSuggestionCell.self, forCellWithReuseIdentifier: tagsSuggestionCellIdentifier)

        
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
        if searchText.count == 0 {
            searchBar.resignFirstResponder() // hides the keyboard.
        }
        if searchText.count > 2 {
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            collectionViewV.isHidden = true
            collectionViewH.isHidden = true
            self.tableView.isHidden = false
            tagService.searchTags(token: token!, search: searchText, completion: { response , error in
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
            collectionViewV.isHidden = false
            collectionViewH.isHidden = false
            self.tableView.isHidden = true
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
        if indexPath.row < filtered.count {
            cell.textLabel?.text = filtered[indexPath.row].name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        searchBar.text = ""
        likeTag(tag: filtered[indexPath.row].id)
        
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
        if collectionView == self.collectionViewV {
            return tagsOfUser.count
        } else {
            return tagsSuggestions.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionViewV {
            return 1
        } else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionViewV {
            return (CGSize(width: 150, height: 40))
        } else {
            return (CGSize(width: 130, height: 40))
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionViewV {
            return sectionInsets
        } else {
            return sectionInsetsSuggestion
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionViewV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagsOfUserCellIdentifier, for: indexPath) as! CustomTagsOfUserCell
            cell.label.text = tagsOfUser[indexPath.row].name
            if isConnectedUser {
                cell.dislikeButton.tag =  tagsOfUser[indexPath.row].id
                cell.dislikeButton.addTarget(self, action: #selector(triggerAlert(_:)), for: .touchUpInside)
            }else {
                cell.dislikeButton.isHidden = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagsSuggestionCellIdentifier, for: indexPath) as! TagSuggestionCell
            cell.label.text = tagsSuggestions[indexPath.row].name
            cell.likeButton.tag =  tagsSuggestions[indexPath.row].id
            cell.likeButton.addTarget(self, action: #selector(likeTagClicked(_:)), for: .touchUpInside)
            return cell
        }
    }
    func setupViews() {
       
        getTagsOfUsers()
        
        if tagsOfUser.isEmpty {
            emptyTagCollectionView.isHidden = false
        }
        if isConnectedUser {
            userConnectedSetupViews()
        }else {
            profileSetupViews()
            
        }
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
    @objc func likeTagClicked(_ sender: UIButton) {
        let tagId = sender.tag
        likeTag(tag: tagId)
    }
   func likeTag(tag: Int) {

        tagService.likeTag(token: token!, id: tag, completion: { response , error in
            if error != nil {
                print ("like tag error:", error!)
            } else {
                if !self.tagsOfUser.contains(where:{$0.id == response!.id}) {
                    self.tagsOfUser.append(response!)
                }
                self.getTagsSuggestion()
                DispatchQueue.main.async{
                    self.filtered = []
                    self.tableView.reloadData()
                    self.tableView.isHidden = true
                    self.collectionViewV.isHidden = false
                    self.collectionViewH.isHidden = false
                    self.collectionViewV.reloadData()
                    self.collectionViewH.reloadData()

                }
            }
            
        })
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
                    self.collectionViewV.isHidden = false
                    self.collectionViewH.isHidden = false
                    self.collectionViewV.reloadData()
                    self.collectionViewH.reloadData()
                }
            }
            
        })
    }
    
    func getTagsSuggestion() {
        tagService.getTagSuggestions(token: token!, completion: { response , error in
            if error != nil {
                print ("get tag suggestion error:", error!)
            } else {
                self.tagsSuggestions = response
                DispatchQueue.main.async{
                    self.emptyTagCollectionView.isHidden = true
                    self.collectionViewH.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
    }
    
    func getTagsOfUsers() {
        tagService.getTagsOfUser(token: token!, userId: user!.id, completion: { response, error in
            if error != nil {
                print ("get tag of user error:", error!)
            } else {
                self.tagsOfUser = response
                DispatchQueue.main.async{
                    if self.tagsOfUser.isEmpty {
                        self.emptyTagCollectionView.isHidden = false
                    } else {
                        self.collectionViewV.isHidden = false
                        self.emptyTagCollectionView.isHidden = true
                    }
                    self.collectionViewV.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
    }
    
    func userConnectedSetupViews() {
        getTagsSuggestion()
        view.addSubview(searchBar)
        view.addSubview(suggestionTagCollectionView)
        view.addSubview(userTagsCollectionView)
        view.addSubview(tableView)
        tableView.isHidden = true
        view.addSubview(indicator)
        view.addSubview(collectionViewH)
        view.addSubview(collectionViewV)
        view.addSubview(emptyTagCollectionView)
        
        if isSubscriberController {
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            searchBar.setValue("Valider", forKey: "cancelButtonText")
            searchBar.setShowsCancelButton(true, animated: true)
            
        } else {
            searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
        
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        suggestionTagCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        suggestionTagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        userTagsCollectionView.topAnchor.constraint(equalTo: collectionViewH.bottomAnchor).isActive = true
        userTagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        
        collectionViewH.topAnchor.constraint(equalTo: suggestionTagCollectionView.bottomAnchor).isActive = true
        collectionViewH.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionViewH.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3).isActive = true
        collectionViewH.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        collectionViewV.topAnchor.constraint(equalTo: userTagsCollectionView.bottomAnchor).isActive = true
        collectionViewV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3).isActive = true
        collectionViewV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3).isActive = true
        collectionViewV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emptyTagCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyTagCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    
    func profileSetupViews() {
        view.addSubview(userTagsCollectionView)
        view.addSubview(indicator)
        userTagsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        userTagsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(collectionViewV)
        view.addSubview(emptyTagCollectionView)
        collectionViewV.topAnchor.constraint(equalTo: userTagsCollectionView.bottomAnchor).isActive = true
        collectionViewV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3).isActive = true
        collectionViewV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3).isActive = true
        collectionViewV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        emptyTagCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyTagCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}
