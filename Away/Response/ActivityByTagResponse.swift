//
//  ActivityByTagResponse.swift
//  Away
//
//  Created by Candice Guitton on 17/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct ActivityByTagResponse: Codable {
    let results: [Activity]
    let token: String?
}
