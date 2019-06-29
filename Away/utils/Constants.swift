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
    
    static let SIGN_IN = BASE_URL + "/auth/login"
    static let SIGN_UP = BASE_URL + "/users"
    
    static let ACTIVITIES_BY_TAG_ROUTE_GOOGLE = BASE_URL + "/activities/googleByCity/"
    static let ACTIVITIES_BY_TAG_ROUTE = BASE_URL + "/activities/ByTag/:idTag"
    static let CITIES_ROUTE = BASE_URL + "/cities/autoCompleteCityName"
    static let TAGS_ROUTE = BASE_URL + "/tags"
    
    static let TAGS_SEARCH_ROUTE = BASE_URL + "/tags/autocompleteNameTag"
    static let TAGS_OF_CONNECTED_USER = BASE_URL + "/tags/ofUser"
    static let LIKE_TAG = BASE_URL + "/tags/like"
    static let DISLIKE_TAG = BASE_URL + "/tags/dislike"
    static let TAGS_SUGGESTION = BASE_URL + "/tags/suggestion/"
    
    static let EVENTS_BY_ACTIVITY_ROUTE = BASE_URL + "/events/getEventsByActivity"
    static let EVENTS_SUGGESTION = BASE_URL + "/activities/suggestion"
    static let CREATE_EVENT = BASE_URL + "/events"
    static let EVENT_DETAILS = BASE_URL + "/events/getEventWithDetails/"
    static let GET_CONNECTED_USER = BASE_URL + "/users/userInfo"
    static let GET_USER_EVENTS = BASE_URL + "/events/getUserEvents"
    static let GET_USER_BY_ID = BASE_URL + "/users/"
    
    static let SEARCH_TAGS = BASE_URL + "/tags/recherche/"
    static let SEARCH_ACTIVITIES = BASE_URL + "/activities/recherche/"
    static let SEARCH_USERS = BASE_URL + "/users/recherche/"
    static let SEARCH_EVENTS = BASE_URL + "/events/recherche/"


}
