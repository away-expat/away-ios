//
//  CustomInfoCell.swift
//  Away
//
//  Created by Candice Guitton on 30/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit

class CustomInfoCell: UITableViewCell {
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        return label;
    }()
    
    let cellView: UIView = {
        let cellView = UIView()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .white
        return cellView
    }()
    let arrowImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "superieur")
        return image
    }()
    func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        cellView.addSubview(arrowImage)
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true

        label.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8).isActive = true
        label.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        arrowImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -15).isActive = true
        arrowImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        arrowImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowImage.widthAnchor.constraint(equalToConstant: 20).isActive = true

    }
    
}
