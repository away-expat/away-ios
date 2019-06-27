//
//  Activity.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct Activity : Codable{
    let id: Int?
    let name: String?
    let address: String?
    let place_id: String?
    let url: String?
    let photos : String?
    let location : String?
    let type:[String]?
    let rating: Float?

}
