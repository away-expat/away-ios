//
//  Event.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

class Event {
    let activity: Activity;
    let date: Date;
    let time: TimeInterval;
    
    init(activity: Activity, date: Date, time: TimeInterval ) {
        self.activity = activity;
        self.date = date;
        self.time = time;
    }
}
