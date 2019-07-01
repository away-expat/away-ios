//
//  CustomEventCell.swift
//  Away
//
//  Created by Candice Guitton on 11/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class CustomHomeEventCell: UITableViewCell {
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
    
    let labelEventTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .white
        return label
    }()
    let labelEventDateTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
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
        cell.addSubview(labelEventTitle)
        cell.addSubview(labelEventDateTime)
        
        cell.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cell.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        labelActivityTitle.topAnchor.constraint(equalTo: cell.topAnchor, constant: 15).isActive = true
        labelActivityTitle.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        labelActivityTitle.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        labelActivityTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true

        cardImage.topAnchor.constraint(equalTo: labelActivityTitle.bottomAnchor, constant: 10).isActive = true
        cardImage.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        cardImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        cardImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        labelEventTitle.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 10).isActive = true
        labelEventTitle.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        labelEventTitle.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        labelEventTitle.heightAnchor.constraint(equalToConstant: 15).isActive = true

        labelEventDateTime.topAnchor.constraint(equalTo: labelEventTitle.bottomAnchor, constant: 10).isActive = true
        labelEventDateTime.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        labelEventDateTime.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        labelEventDateTime.heightAnchor.constraint(equalToConstant: 15).isActive = true
        labelEventDateTime.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -30).isActive = true

    }
}
