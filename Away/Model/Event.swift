//
//  Event.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct Event : Codable {
    let id: Int
    let title: String
    let activityName: String
    let activityId: Int
    let date: String
    let hour: String
    let description: String
    let owner: User
    let photo: String
}
