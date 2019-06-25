//
//  CityService.swift
//  Away
//
//  Created by Candice Guitton on 13/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class EventService {
    
    func getEventsByActivity(token: String, completion: @escaping ([Event], ErrorType?) -> ()) {
        
        let urlString = Constants.EVENTS_BY_ACTIVITY_ROUTE
        let urlComponent = URLComponents(string: urlString)
        if urlComponent == nil { completion([], ErrorType.badUrl) }
        guard let url = urlComponent?.url else { return }
        var request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
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
    
    func getUserEvents(token: String, completion: @escaping ([Event], ErrorType?) -> ()) {
        print(token)
        let urlString = Constants.GET_USER_EVENTS
        let urlComponent = URLComponents(string: urlString)
        if urlComponent == nil { completion([], ErrorType.badUrl) }
        guard let url = urlComponent?.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
            print(request)
        guard let data = data else {return}
        
        if let httpResponse = response as? HTTPURLResponse {
            print("error \(httpResponse.statusCode)")
            if (httpResponse.statusCode == 401) {
                completion([], ErrorType.unauthorized)
                return
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
    
    func getEvents(token: String, search: String, completion: @escaping ([Event], ErrorType?) -> ()) {
        
        let urlString = Constants.SEARCH_EVENTS + search
        let url = URL(string: urlString)
        if url == nil { completion([], ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
        print(request)
        
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

