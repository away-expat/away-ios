//
//  CreateEventResponse.swift
//  Away
//
//  Created by Candice Guitton on 27/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
struct EventDetailsResponse: Codable{
    var creator: Creator
    var event: EventItem
    var activity: Activity
    var participant: [UserList]
    var tag: [Tag]
}
