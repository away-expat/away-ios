//
//  TabSearchCustomEventCell.swift
//  Away
//
//  Created by Candice Guitton on 24/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class TabSearchCustomEventCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.init(name: "AmericanTypewriter", size: 20)
        label.sizeToFit()
        return label
    }()
    
    let dateTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16.0)
        label.sizeToFit()
        return label
    }()
    let avatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .white
        return cellView
    }()
    
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(title)
        cellView.addSubview(dateTime)
        cellView.addSubview(avatarImageView)
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        avatarImageView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20).isActive = true
        
        title.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 25).isActive = true
        title.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 10).isActive = true

        dateTime.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10).isActive = true
        dateTime.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        
    }
    
}

