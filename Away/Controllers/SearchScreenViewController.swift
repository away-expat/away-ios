//
//  SearchScreenViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess
import Kingfisher

class SearchScreenViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CustomSegmentedControlDelegate, ChangeCitiesDelegate {
    func changeTab(index: Int) {
        switch index {
        case 0:
            currentTab = 0
            if searchQuery != nil && searchQuery!.count > 2 {
                startLoading()
                getActivities(search: searchQuery!)
            }
            break
        case 1:
            currentTab = 1
            if searchQuery != nil && searchQuery!.count > 2 {
                startLoading()
                getEvents(search: searchQuery!)
            }
            break
        case 2:
            currentTab = 2
            if searchQuery != nil && searchQuery!.count > 2 {
                startLoading()
                getTags(search: searchQuery!)
            }
            break
        case 3:
            currentTab = 3
            if searchQuery != nil && searchQuery!.count > 2 {
                startLoading()
                getUsers(search: searchQuery!)
            }
            break
        default:
            break
        }
    }
    var currentTab: Int = 0
    var tags: [Tag] = []
    let tagService = TagService()
    let tagTabCellIdentifier = "tagTabCellId"
    var users: [User] = []
    let userService = UserService()
    let userTabCellIdentifier = "userTabCellId"

    var activities: [Activity] = []
    let activityService = ActivityService()
    let activityTabCellIdentifier = "activityTabCellId"

    var events: [Event] = []
    let eventService = EventService()
    let eventTabCellIdentifier = "eventTabCellId"

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let emptyCollectionView : UILabel = {
        let label = UILabel()
        label.text = "Pas de résultat"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var user : User?
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    var searchQuery:String?
    var codeSegmented :SegmentedControl?
    var loadMoreToken: String?
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(named: "AppLightGrey")
            textfield.attributedPlaceholder = NSAttributedString(string: "Rechercher", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
            textfield.returnKeyType = .done
            textfield.resignFirstResponder() // hides the keyboard.
        }
        
        sb.layer.cornerRadius = 20
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = .white
        sb.backgroundImage = UIImage()
        return sb
    }()
    let searchTabIcon : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "searchTab"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .gray
        return iv
    }()
    let tableView = UITableView()
    override func viewWillAppear(_ animated: Bool) {
        codeSegmented?.setIndex(index: currentTab)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getConnectedUser()
    }
    func startLoading() {
        tableView.isHidden = true
        indicator.isHidden = false
    }
    func getConnectedUser() {
        userService.getConnectedUser(token: token!, completion: { response , error in
            if error != nil {
                print ("search screen error:", error!)
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
        navigationItem.title = user?.at.name

        codeSegmented = SegmentedControl(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 40), buttonTitle: ["location", "event", "tag", "people"])
        codeSegmented!.backgroundColor = .clear
        codeSegmented!.segmentControlDelegate = self
        view.addSubview(codeSegmented!)
        view.addSubview(searchBar)
        view.addSubview(indicator)
        view.addSubview(emptyCollectionView)
        view.addSubview(tableView)
        view.addSubview(searchTabIcon)
        
        
        searchBar.delegate = self
        
        searchBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
        emptyCollectionView.isHidden = true
        emptyCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchTabIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTabIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.topAnchor.constraint(equalTo: codeSegmented!.bottomAnchor, constant: 10).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        tableView.register(TabSearchCustomActivityCell.self, forCellReuseIdentifier: activityTabCellIdentifier)
        tableView.register(TabSearchCustomEventCell.self, forCellReuseIdentifier: eventTabCellIdentifier)
        tableView.register(TabSearchCustomTagCell.self, forCellReuseIdentifier: tagTabCellIdentifier)
        tableView.register(TabSearchCustomUserCell.self, forCellReuseIdentifier: userTabCellIdentifier)

       
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchBar.resignFirstResponder() // hides the keyboard.
        }
        searchQuery = searchText
        if searchText.count > 2 {
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            tableView.isHidden = true
            searchTabIcon.isHidden = true

            switch self.currentTab {
            case 0:
                startLoading()
                getActivities(search: searchText)
            case 1:
                startLoading()
                getEvents(search: searchText)
            case 2:
                startLoading()
                getTags(search: searchText)

            case 3:
                startLoading()
                getUsers(search: searchText)
            default:
                break
            }
            
        } else {
            users = []
            activities = []
            tags = []
            events = []
            searchTabIcon.isHidden = false
            self.tableView.isHidden = true
            self.indicator.stopAnimating()
            self.emptyCollectionView.isHidden = true
            self.tableView.reloadData()
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentTab {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: activityTabCellIdentifier, for: indexPath) as! TabSearchCustomActivityCell
            if indexPath.row < activities.count {
                cell.label.text = activities[indexPath.row].name
                let url = URL(string: activities[indexPath.row].photos!)
                cell.avatarImageView.kf.setImage(with: url)
                if indexPath.row == activities.count - 1 {
                    loadMore()
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: eventTabCellIdentifier, for: indexPath) as! TabSearchCustomEventCell
            if indexPath.row < events.count {
                cell.title.text = events[indexPath.row].title
                cell.dateTime.text =  events[indexPath.row].date + " " + events[indexPath.row].hour
                let url = URL(string: events[indexPath.row].photo)
                cell.avatarImageView.kf.setImage(with: url)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: tagTabCellIdentifier, for: indexPath) as! TabSearchCustomTagCell
            if indexPath.row < tags.count {
                cell.label.text = tags[indexPath.row].name
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: userTabCellIdentifier, for: indexPath) as! TabSearchCustomUserCell
            if indexPath.row < users.count {
                cell.username.text = users[indexPath.row].firstname + " " + users[indexPath.row].lastname
                cell.country.text =  users[indexPath.row].country
                let url = URL(string: users[indexPath.row].avatar)
                cell.avatarImageView.kf.setImage(with: url)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentTab {
        case 0:
            return activities.count
        case 1:
            return events.count
        case 2:
            return tags.count
        case 3:
            return users.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.currentTab {
        case 0:
            let activityDetailsController = ActivityDetailsController()
            activityDetailsController.activity = activities[indexPath.row]
            self.navigationController?.pushViewController(activityDetailsController, animated: true)
            print("selected cell \(indexPath.row) in index \(currentTab)")
            break
        case 1:
            let eventDetailsController = EventDetailsController()
            eventDetailsController.eventId = events[indexPath.row].id
            self.navigationController?.pushViewController(eventDetailsController, animated: true)
            print("selected cell \(indexPath.row) in index \(currentTab)")
            break
        case 2:
            let listActivityByTagController = ListActivityByTagController()
            listActivityByTagController.tag = tags[indexPath.row]
            self.navigationController?.pushViewController(listActivityByTagController, animated: true)
            print("selected cell \(indexPath.row) in index \(currentTab)")
            break
        case 3:
            let userProfileController = UserProfileViewController()
            userProfileController.user = users[indexPath.row]
            userProfileController.userId = users[indexPath.row].id
            self.navigationController?.pushViewController(userProfileController, animated: true)
            print("selected cell \(indexPath.row) in index \(currentTab)")
            break
        default:
            break
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
   
    func getTags(search: String) {
        tagService.searchTags(token: token!, search: search, completion: { response , error in
            if error != nil {
                print ("get tags error:", error!)
            } else {
                self.tags = response
                DispatchQueue.main.async{
                    if self.tags.isEmpty {
                        self.emptyCollectionView.isHidden = false
                    } else {
                        self.emptyCollectionView.isHidden = true
                        self.tableView.isHidden = false

                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    func getActivities(search: String) {
        activityService.getActivities(token: token!, search: search, completion: { response, loadMoreToken, error in
            if error != nil {
                print ("get activities error:", error!)
            } else {
                self.activities = response
                self.loadMoreToken = loadMoreToken
                DispatchQueue.main.async{
                    if self.activities.isEmpty {
                        self.emptyCollectionView.isHidden = false
                    } else {
                        self.emptyCollectionView.isHidden = true
                        self.tableView.isHidden = false
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    func getUsers(search: String) {
        userService.getUsers(token: token!, search: search, completion: { response , error in
            if error != nil {
                print ("get users error:", error!)
            } else {
                self.users = response
                DispatchQueue.main.async{
                    if self.users.isEmpty {
                        self.emptyCollectionView.isHidden = false
                    } else {
                        self.emptyCollectionView.isHidden = true
                        self.tableView.isHidden = false
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    func getEvents(search: String) {
        eventService.getEvents(token: token!, search: search, completion: { response , error in
            if error != nil {
                print ("get events error:", error!)
            } else {
                self.events = response
                DispatchQueue.main.async{
                    if self.events.isEmpty {
                        self.emptyCollectionView.isHidden = false
                    } else {
                        self.emptyCollectionView.isHidden = true
                        self.tableView.isHidden = false
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        KeyboardUtils.WillChange(notification: notification, view: view)
        
    }
    

    func loadMore() {
        activityService.loadMore(token: token!, loadMoreToken: loadMoreToken!,  completion: { response, loadMoreToken, error in
            if error != nil {
                print ("load more error:", error!)
            } else {
                self.activities += response
                self.loadMoreToken = loadMoreToken
                DispatchQueue.main.async{
                    if self.activities.isEmpty {
                        self.emptyCollectionView.isHidden = false
                    } else {
                        self.emptyCollectionView.isHidden = true
                        self.tableView.isHidden = false
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.searchBar.endEditing(true)
    }
}
