//
//  Event.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct Event : Codable {
    let activityName: String
    let activityId: Int
    let date: Date
    let time: TimeInterval
    let description: String
    let owner: User
}
