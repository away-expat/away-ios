//
//  CustomTagCell.swift
//  Away
//
//  Created by Candice Guitton on 10/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class CustomTagCell: UICollectionViewCell {
    
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
        label.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16.0)
        label.sizeToFit()
        return label;
    }()
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = UIColor(named: "AppPeach")
        return cellView
    }()
    
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: cellView.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 0).isActive = true
        
    }
    
}
