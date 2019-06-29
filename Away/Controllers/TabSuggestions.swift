//
//  TabSuggestions.swift
//  Away
//
//  Created by Candice Guitton on 29/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
class TagSuggestionCell: UICollectionViewCell {
    
    let tagsSuggestionCellIdentifier = "tagsSuggestionCellId"

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
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
        label.sizeToFit()
        return label
    }()
    let likeButton :UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like"), for: .normal)
        return button
    }()
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = UIColor(named: "AppLightOrange")
        cellView.layer.cornerRadius = 5
        return cellView
    }()
    
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        cellView.addSubview(likeButton)
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor).isActive = true
        likeButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5).isActive = true
        likeButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true

    }
    
}

