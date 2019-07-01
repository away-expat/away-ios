//
//  CustomActivityCell.swift
//  Away
//
//  Created by Candice Guitton on 16/05/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class CustomActivityCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let labelActivityTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .white
        return label
    }()
    
    let cell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    func setupViews() {
        contentView.addSubview(cell)
        cell.addSubview(labelActivityTitle)
        cell.addSubview(cardImage)
   
        
        cell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        cardImage.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        cardImage.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        cardImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        cardImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    
        labelActivityTitle.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 15).isActive = true
        labelActivityTitle.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        labelActivityTitle.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        labelActivityTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
       
    }
   
}
