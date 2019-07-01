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
    let arrow: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "event")
        iv.image = image
        return iv
    }()
    let titleEvent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    let dateEvent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    let timeEvent: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .white
        return cellView
    }()
    
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(arrow)
        cellView.addSubview(titleEvent)
        cellView.addSubview(dateEvent)
        cellView.addSubview(timeEvent)

        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        
        
        arrow.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        arrow.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5).isActive = true
        arrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        arrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleEvent.centerYAnchor.constraint(equalTo: cellView.centerYAnchor, constant: -5).isActive = true
        titleEvent.leadingAnchor.constraint(equalTo: arrow.trailingAnchor, constant: 15).isActive = true

        dateEvent.topAnchor.constraint(equalTo: titleEvent.bottomAnchor, constant: 4).isActive = true
        dateEvent.leadingAnchor.constraint(equalTo: arrow.trailingAnchor, constant: 15).isActive = true
        
        timeEvent.topAnchor.constraint(equalTo: titleEvent.bottomAnchor, constant: 4).isActive = true
        timeEvent.leadingAnchor.constraint(equalTo: dateEvent.trailingAnchor, constant: 5).isActive = true
        
    }
    
}
