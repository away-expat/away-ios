//
//  ActivityService.swift
//  Away
//
//  Created by Candice Guitton on 10/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class ActivityService {
    
//    func getActivities(token: String, completion: @escaping ([Activity], ErrorType?) -> ()) {
//
//        let urlString = Constants.ACTIVITIES_ROUTE_GOOGLE+"/paris/bar"
//        let url = URL(string: urlString)
//        if url == nil { completion([], ErrorType.badUrl) }
//        var request = URLRequest(url: url!)
//        let token = token
//        request.setValue(token, forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//        guard let data = data else {return}
//
//        if let httpResponse = response as? HTTPURLResponse {
//            print("error \(httpResponse.statusCode)")
//            if (httpResponse.statusCode == 401) {
//                completion([], ErrorType.unauthorized)
//            }
//        }
//
//        do {
//            let decoder = JSONDecoder()
//            let response = try decoder.decode([Activity].self, from: data)
//            completion(response, nil)
//        } catch let errorJson {
//            completion([], ErrorType.serverError)
//            print(errorJson)
//            return
//        }
//
//        }.resume()
//    }
    
    func getActivitiesByTag(token: String, city:String, tag: Tag, completion: @escaping ([Activity], ErrorType?) -> ()) {
        
        let urlString = Constants.ACTIVITIES_BY_TAG_ROUTE_GOOGLE+city+"/"+tag.name
        let urlComponent = URLComponents(string: urlString)
        if urlComponent == nil { completion([], ErrorType.badUrl) }
        
        guard let url = urlComponent?.url else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = token
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
                let response = try decoder.decode(ActivityByTagResponse.self, from: data)
                
                completion(response.results, nil)
            } catch let errorJson {
                completion([], ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
    
    func getSuggestions(token: String, completion: @escaping ([Event], ErrorType?) -> ()) {
        
        let urlString = Constants.EVENTS_SUGGESTION
        let url = URL(string: urlString)
        if url == nil { completion([], ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = token
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
                let response = try decoder.decode(SuggestionEventsReponse.self, from: data)
                completion(response.results, nil)
            } catch let errorJson {
                completion([], ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
}

