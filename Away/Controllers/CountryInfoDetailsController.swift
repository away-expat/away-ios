//
//  CountryInfoDetailsController.swift
//  Away
//
//  Created by Candice Guitton on 30/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
import KeychainAccess
class CountryInfoDetailsController: UIViewController {
    static var keychain: Keychain?
    let token = App.keychain!["token"]
    let informationService = InformationService()
    var infos : Information?
    var infoId : Int?
    let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
    let infoTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let infoContent : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        if infoId != nil {
            getInfoById(infoId: infoId!)
        }
    }
    func setupViews() {
        view.addSubview(indicator)
        view.addSubview(infoTitle)
        view.addSubview(infoContent)
        
        
        infoTitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        infoTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant : 8).isActive = true
        infoTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        infoContent.topAnchor.constraint(equalTo: infoTitle.bottomAnchor, constant: 20).isActive = true
        infoContent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant : 8).isActive = true
        infoContent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant : -8).isActive = true
        infoContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant : -8).isActive = true
        infoTitle.text = infos?.title
        infoContent.text = infos?.content
        
    }
    func getInfoById(infoId: Int) {
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        informationService.getInfosById(token: token!, infoId: infoId, completion: { response , error in
            if error != nil {
                print ("get infos by id error:", error!)
            } else {
                self.infos = response
                DispatchQueue.main.async{
                    self.setupViews()
                    self.indicator.stopAnimating()
                }
            }
            
        })
    }
}
