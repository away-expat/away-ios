//
//  CustomTagsOfUserCell.swift
//  Away
//
//  Created by Candice Guitton on 21/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class CustomTagsOfUserCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "Arial", size: 13.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = UIColor(named: "AppPeach")
        cellView.layer.cornerRadius = 5
        return cellView
    }()

    let dislikeButton :UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "delete"), for: .normal)
        return button
    }()
    
    
     func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        cellView.addSubview(dislikeButton)
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: dislikeButton.leadingAnchor).isActive = true
        dislikeButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5).isActive = true
        dislikeButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true

    }
   
}
