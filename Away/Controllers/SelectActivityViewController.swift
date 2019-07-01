//
//  SelectActivityViewController.swift
//  Away
//
//  Created by Candice Guitton on 26/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
import Kingfisher
class SelectActivityViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let activityService = ActivityService()
    var activityDelegate: SelectActivityDelegate?
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(named: "AppLightGrey")
            textfield.attributedPlaceholder = NSAttributedString(string: "Rechercher une activité", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
        }
        sb.setValue("Annuler", forKey: "cancelButtonText")
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
    let emptyList : UILabel = {
        let label = UILabel()
        label.text = "Sélectionner une activité"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView = UITableView()
    
    
    var searchActive : Bool = false
    var filtered:[Activity] = []
    let activityTabCellIdentifier = "activityCellId"
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    func setupViews() {
        view.addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.setShowsCancelButton(true, animated: true)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.addSubview(emptyList)
        emptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(TabSearchCustomActivityCell.self, forCellReuseIdentifier: activityTabCellIdentifier)
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            activityService.getActivities(token: token!, search: searchText, completion: { response , loadMoreToken, error in
                if error != nil {
                    print ("select activity error:", error!)
                } else {
                    self.filtered = response
                    
                    DispatchQueue.main.async{
                        if self.filtered.isEmpty {
                            self.emptyList.isHidden = false
                        } else {
                            self.emptyList.isHidden = true
                            
                        }
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
                
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activityTabCellIdentifier, for: indexPath) as! TabSearchCustomActivityCell
        if indexPath.row < filtered.count {
            cell.label.text = filtered[indexPath.row].name
            let url = URL(string: filtered[indexPath.row].photos!)
            cell.avatarImageView.kf.setImage(with: url)
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        print("", filtered[indexPath.row])
        getCityNameInSearchBar(activity: filtered[indexPath.row])
    }
    func getCityNameInSearchBar(activity: Activity) {
        activityDelegate?.onActivitySelected(activity: activity)
        dismissView()
    }
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
        
    }
}

protocol SelectActivityDelegate {
    func onActivitySelected(activity: Activity)
}
