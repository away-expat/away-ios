//
//  CustomTagSearchCell.swift
//  Away
//
//  Created by Candice Guitton on 20/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class CustomTagSearchCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
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
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.centerXAnchor.constraint(equalTo: cellView.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: 0).isActive = true
        
    }
    
}
