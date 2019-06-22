//
//  ChangeCountryViewController.swift
//  Away
//
//  Created by Candice Guitton on 17/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class ChangeCitiesViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let cityService = CityService()
    var cityDelegate: ChangeCitiesDelegate?
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        if let textfield = sb.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(named: "AppLightGrey")
            textfield.attributedPlaceholder = NSAttributedString(string: "Rechercher une ville", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
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
        label.text = "Choisissez une ville à visiter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView = UITableView()


    var searchActive : Bool = false
    var cities : [City] = []
    var filtered:[City] = []
    let cityCellIdentifier = "cityCellId"

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
        navigationItem.title = "Japan"

        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.register(CustomCityCell.self, forCellReuseIdentifier: cityCellIdentifier)

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        dismissView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            cityService.getCities(search: searchText, completion: { response , error in
                if error != nil {
                    print ("change cities error:", error!)
                } else {
                    self.cities = response
                    
                    DispatchQueue.main.async{
                        if self.cities.isEmpty {
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
        filtered = cities.filter({ (city) -> Bool in
            let tmp: NSString = city.name as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return cities.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier) as! CustomCityCell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row].name + " " + cities[indexPath.row].country
        } else {
            cell.textLabel?.text = cities[indexPath.row].name + " " + cities[indexPath.row].country
        }
        
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected cell \(indexPath.row)")
        if searchActive {
            getCityNameInSearchBar(city: filtered[indexPath.row])
            print("", filtered[indexPath.row])
        } else {
            print("", cities[indexPath.row])
            getCityNameInSearchBar(city: cities[indexPath.row])
        }
        
    }
    func getCityNameInSearchBar(city: City) {
        searchBar.text = city.name
        cityDelegate?.onCitiesChanged(city: city)
        dismissView()
    }
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
        
    }
}

protocol ChangeCitiesDelegate {
    func onCitiesChanged(city: City)
}

