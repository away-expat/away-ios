//
//  User.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct User: Codable{
    
    let firstname: String
    let lastname: String
    let fromCountry: String
    let visitedCity: City
}
