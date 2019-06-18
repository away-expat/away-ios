//
//  CustomEventCell.swift
//  Away
//
//  Created by Candice Guitton on 11/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
import UIKit

class CustomEventCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = .white
        return label;
    }()
    
    let card: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardImage : UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "imageBG"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let checkMark : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    func setupViews() {
        contentView.addSubview(card)
        card.addSubview(cardImage)
        cardImage.addSubview(label)
        
        card.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        card.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        card.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        card.layer.shadowOpacity = 1.0
        card.layer.shadowRadius = 2.0
        
        cardImage.leftAnchor.constraint(equalTo: card.leftAnchor).isActive = true
        cardImage.rightAnchor.constraint(equalTo: card.rightAnchor).isActive = true
        cardImage.topAnchor.constraint(equalTo: card.topAnchor).isActive = true
        cardImage.bottomAnchor.constraint(equalTo: card.bottomAnchor).isActive = true
        
        //label.topAnchor.constraint(equalTo: cardImage.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: cardImage.bottomAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cardImage.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: cardImage.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func addEvent() -> Void {
        // checkMark.image = UIImage(named: "check-mark")
    }
}
