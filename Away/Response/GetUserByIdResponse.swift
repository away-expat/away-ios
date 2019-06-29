//
//  GetUserByIdResponse.swift
//  Away
//
//  Created by Candice Guitton on 28/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct GetUserByIdResponse : Codable{
    let id: Int
    var firstname: String
    var lastname: String
    var country: String
    var birth: String
    var at: City
    var avatar: String
}
