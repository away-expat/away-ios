//
//  CustomEventListCell.swift
//  Away
//
//  Created by Candice Guitton on 22/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
class CustomEventListCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleEvent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label;
    }()
    let dateEvent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label;
    }()
    let timeEvent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label;
    }()
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .white
        return cellView
    }()
    
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(titleEvent)
        cellView.addSubview(dateEvent)
        cellView.addSubview(timeEvent)

        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        titleEvent.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 3).isActive = true
        titleEvent.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5).isActive = true
        
        dateEvent.topAnchor.constraint(equalTo: titleEvent.bottomAnchor, constant: 4).isActive = true
        dateEvent.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5).isActive = true
        
        timeEvent.topAnchor.constraint(equalTo: dateEvent.bottomAnchor, constant: 4).isActive = true
        timeEvent.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5).isActive = true
        
    }
    
}
