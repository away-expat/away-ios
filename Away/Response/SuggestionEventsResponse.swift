//
//  SuggestionEventsResponse.swift
//  Away
//
//  Created by Candice Guitton on 21/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
struct SuggestionEventsReponse: Codable {
    let results: [Event]
    let token: String
}

