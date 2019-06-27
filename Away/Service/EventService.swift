//
//  CityService.swift
//  Away
//
//  Created by Candice Guitton on 13/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class EventService {
    
    func createEvent(token: String, title: String, description: String, date: String, time: String, activity: Int, completion: @escaping (Event?, ErrorType?) -> ()){
        
        let urlString = Constants.CREATE_EVENT
        let url = URL(string: urlString)
        if url == nil { completion(nil, ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let parameters = [
            "title": title,
            "description": description,
            "date": date,
            "hour": time,
            "idActivity": activity
            ] as [String:Any]
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .init())
            request.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from data")
            return
        }
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 401) {
                    completion(nil, ErrorType.unauthorized)
                }
            }
            
            do {
                let json = JSONDecoder()
                let response = try json.decode(Event.self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion(nil, ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
    func getEventsByActivity(token: String, activityId: Int, completion: @escaping ([Event], ErrorType?) -> ()) {
        
        let urlString = Constants.EVENTS_BY_ACTIVITY_ROUTE + "/" + activityId.description
        let url = URL(string: urlString)
        if url == nil { completion([], ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")

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
    
    func getUserEvents(token: String, completion: @escaping ([Event], ErrorType?) -> ()) {

        let urlString = Constants.GET_USER_EVENTS
        let url = URL(string: urlString)
        if url == nil { completion([], ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
   
        URLSession.shared.dataTask(with: request) { (data, response, error) in
        request.setValue(token, forHTTPHeaderField: "Authorization")
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
