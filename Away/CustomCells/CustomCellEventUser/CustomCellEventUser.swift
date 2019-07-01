//
//  CustomCellEventUser.swift
//  Away
//
//  Created by Candice Guitton on 01/07/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class CustomCellEventUser: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        cell.addSubview(cardImage)
        cell.addSubview(labelEventTitle)
        cell.addSubview(labelEventDateTime)
        
        cell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cell.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        cardImage.topAnchor.constraint(equalTo: cell.topAnchor, constant: 5).isActive = true
        cardImage.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        cardImage.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        cardImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        labelEventTitle.topAnchor.constraint(equalTo: cardImage.bottomAnchor, constant: 5).isActive = true
        labelEventTitle.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        labelEventTitle.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        labelEventTitle.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        labelEventDateTime.topAnchor.constraint(equalTo: labelEventTitle.bottomAnchor, constant: 5).isActive = true
        labelEventDateTime.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
        labelEventDateTime.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -5).isActive = true
        labelEventDateTime.heightAnchor.constraint(equalToConstant: 15).isActive = true        
    }
}
