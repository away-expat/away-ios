//
//  User.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct User: Codable{
    
    var id: Int
    var firstname: String
    var lastname: String
    var mail: String
    var country: String
    var birth: String
    var token: String
    var at: City
    var avatar: String
}
