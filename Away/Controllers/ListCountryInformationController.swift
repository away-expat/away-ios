//
//  ConvenientInformationController.swift
//  Away
//
//  Created by Candice Guitton on 03/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
class ListCountryInformationController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeCitiesDelegate {
    
    let informationService = InformationService()
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let emptyList : UILabel = {
        let label = UILabel()
        label.text = "Aucun article"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let headerTitle : UILabel = {
        let label = UILabel()
        label.text = "Informations pratiques"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let headerDescription : UILabel = {
        let label = UILabel()
        label.text = "Retrouvez par catégories les infos que nous avons recueillis sur votre pays d’accueil"
        label.numberOfLines = 2
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let tableView = UITableView()
    var infos :[Information] = []
    let infoCellIdentifier = "infoCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setConstraint()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    func setupViews() {
        navigationController?.navigationBar.isTranslucent = false
        let planetIcon = UIImage(named: "earth")
        let planetImageView = UIImageView()
        planetImageView.image = planetIcon?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: -7, right: 0))
        let button = UIBarButtonItem(image: planetImageView.image, style: .plain, target: self, action: #selector(chooseCityToVisitButtonClicked))
        navigationItem.rightBarButtonItem = button
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        
        view.addSubview(headerTitle)
        view.addSubview(headerDescription)
        view.addSubview(tableView)
        getInfos()
        
    }
    func setConstraint() {
        headerTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive =  true
        headerTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive =  true
        headerTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive =  true
        headerTitle.heightAnchor.constraint(equalToConstant: 25).isActive =  true

        headerDescription.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 8).isActive =  true
        headerDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive =  true
        headerDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8).isActive =  true
        headerDescription.heightAnchor.constraint(equalToConstant: 30).isActive =  true
        
        tableView.separatorStyle = .none
        tableView.topAnchor.constraint(equalTo: headerDescription.bottomAnchor, constant: 20).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(CustomInfoCell.self, forCellReuseIdentifier: infoCellIdentifier)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! CustomInfoCell
        if indexPath.row < infos.count {
            cell.label.text = infos[indexPath.row].title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let countryInfoDetailController = CountryInfoDetailsController()
        countryInfoDetailController.infoId = infos[indexPath.row].id
        self.navigationController?.pushViewController(countryInfoDetailController, animated: true)
    }
    
    func getInfos() {
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        informationService.getInfos(token: token!, completion: { response , error in
            if error != nil {
                print ("get infos error:", error!)
            } else {
                self.infos = response
                DispatchQueue.main.async{
                    if self.infos.isEmpty {
                        self.emptyList.isHidden = false
                    } else {
                        self.emptyList.isHidden = true
                        self.tableView.isHidden = false
                        
                    }
                    self.indicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }
            
        })
    }
    func onCitiesChanged(city: City) {
        navigationItem.title = city.name
    }
    
    @objc func chooseCityToVisitButtonClicked() {
        let changeCitiesViewController = ChangeCitiesViewController()
        changeCitiesViewController.cityDelegate = self
        present(changeCitiesViewController, animated: true)
    }
}
