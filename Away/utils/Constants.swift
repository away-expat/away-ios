//
//  Constants.swift
//  Away
//
//  Created by Candice Guitton on 10/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//

import Foundation
class Constants {
    static let BASE_URL = "http://51.75.122.187:3000"
    static let ACTIVITIES_ROUTE_GOOGLE = BASE_URL + "/activities/googleByCity"
    static let ACTIVITIES_BY_TAG_ROUTE_GOOGLE = BASE_URL + "/activities/googleByCity"
    static let ACTIVITIES_BY_TAG_ROUTE = BASE_URL + "/activities/ByTag/:idTag"
    static let CITIES_ROUTE = BASE_URL + "/cities"
    static let TAGS_ROUTE = BASE_URL + "/tags"
    static let EVENTS_BY_ACTIVITY_ROUTE = BASE_URL + "/getEventsByActivity"

}
