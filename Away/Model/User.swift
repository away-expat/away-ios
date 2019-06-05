//
//  User.swift
//  Away
//
//  Created by Candice Guitton on 06/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation

class User {
    
    let firstname: String;
    let lastname: String;
    let birthdate: Date;
    let country: String;
    let tags: [Tag];
    let events: [Event];
    
    init(firstname: String, lastname:String, birthdate: Date, country: String, tags: [Tag], events: [Event]) {
        self.firstname = firstname;
        self.lastname = lastname;
        self.birthdate = birthdate;
        self.country = country;
        self.tags = tags;
        self.events = events;
    }
}
