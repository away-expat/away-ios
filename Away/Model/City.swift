//
//  City.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

class City {
    let name: String;
    let activities: [Activity];
    
    init(name: String, activities: [Activity]) {
        self.name = name;
        self.activities = activities;
    }
}
