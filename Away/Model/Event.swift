//
//  Event.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

struct Event : Codable {
    var id: Int
    var title: String
    var activityName: String
    var activityId: Int
    var date: String
    var hour: String
    var description: String
    var photo: String
    var promoted: Bool
}
