//
//  CityService.swift
//  Away
//
//  Created by Candice Guitton on 13/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class EventService {
    
    func getEventsByActivity(activityId: String, completion: @escaping ([Event], ErrorType?) -> ()) {
        
        let urlString = Constants.EVENTS_BY_ACTIVITY_ROUTE
        var urlComponent = URLComponents(string: urlString)
        if urlComponent == nil { completion([], ErrorType.badUrl) }
        urlComponent?.query = activityId
        guard let url = urlComponent?.url else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 401) {
                    completion([], ErrorType.unauthorized)
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([Event].self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion([], ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
}

