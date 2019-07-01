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

    let emptyList : UILabel = {
        let label = UILabel()
        label.text = "Choisissez une ville à visiter"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let citiesList : UILabel = {
        let label = UILabel()
        label.text = "Les villes les plus visitées"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView = UITableView()
    let tableViewCitiesSuggestion = UITableView()
    var citiesSuggestion : [City] = []
    var searchActive : Bool = false
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
        view.addSubview(tableViewCitiesSuggestion)
        view.addSubview(citiesList)
        view.addSubview(indicator)
        view.addSubview(emptyList)

        tableViewCitiesSuggestion.separatorStyle = .none
        tableViewCitiesSuggestion.translatesAutoresizingMaskIntoConstraints = false
        tableViewCitiesSuggestion.topAnchor.constraint(equalTo: citiesList.bottomAnchor).isActive = true
        tableViewCitiesSuggestion.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewCitiesSuggestion.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewCitiesSuggestion.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        citiesList.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        citiesList.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        citiesList.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        tableViewCitiesSuggestion.delegate = self
        tableViewCitiesSuggestion.dataSource = self
        searchBar.delegate = self
        tableViewCitiesSuggestion.register(CustomCityCell.self, forCellReuseIdentifier: cityCellIdentifier)
        tableView.register(CustomCityCell.self, forCellReuseIdentifier: cityCellIdentifier)
        getCitiesSuggestion()
    }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            indicator.startAnimating()
            indicator.hidesWhenStopped = true
            tableViewCitiesSuggestion.isHidden = true
            citiesList.isHidden = true
            cityService.getCities(search: searchText, completion: { response , error in
                if error != nil {
                    print ("change cities error:", error!)
                } else {
                    self.filtered = response
                    
                    DispatchQueue.main.async{
                        if self.filtered.isEmpty {
                            self.emptyList.isHidden = false
                        } else {
                            self.tableView.isHidden = false
                            self.emptyList.isHidden = true

                        }
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                    }
                }
                
            })
        } else {
            tableView.isHidden = true
            tableViewCitiesSuggestion.isHidden = false
            citiesList.isHidden = false
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
        if tableView == tableViewCitiesSuggestion {
            return citiesSuggestion.count
        }
        return filtered.count;

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cityCellIdentifier) as! CustomCityCell;
        if tableView == tableViewCitiesSuggestion {
            cell.textLabel?.text = citiesSuggestion[indexPath.row].name + " " + citiesSuggestion[indexPath.row].country
        } else {
            cell.textLabel?.text = filtered[indexPath.row].name + " " + filtered[indexPath.row].country

        }
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewCitiesSuggestion {
            if indexPath.row < citiesSuggestion.count {
                getCityNameInSearchBar(city: citiesSuggestion[indexPath.row])
            }
        }else {
            if indexPath.row < filtered.count {
                getCityNameInSearchBar(city: filtered[indexPath.row])
            }
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
    func getCitiesSuggestion() {
        cityService.getCitiesSuggestion(completion: { response , error in
            if error != nil {
                print ("get cities suggestion error:", error!)
            } else {
                self.citiesSuggestion = response
                
                DispatchQueue.main.async{
                    if self.citiesSuggestion.isEmpty {
                        self.emptyList.isHidden = false
                    } else {
                        self.emptyList.isHidden = true
                        
                    }
                    self.tableViewCitiesSuggestion.reloadData()
                    self.indicator.stopAnimating()
                }
            }
            
        })
    }
    
}

protocol ChangeCitiesDelegate {
    func onCitiesChanged(city: City)
}

