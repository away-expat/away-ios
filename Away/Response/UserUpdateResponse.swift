//
//  UserUpdateResponse.swift
//  Away
//
//  Created by Candice Guitton on 02/07/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import UIKit
struct UserUpdateResponse: Codable {
    var id: Int
    var firstname: String
    var lastname: String
    var mail: String
    var country: String
    var birth: String
    var token: String
}
