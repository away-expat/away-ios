//
//  ActivityService.swift
//  Away
//
//  Created by Candice Guitton on 10/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class ActivityService {
    
    func getActivities(completion: @escaping ([Activity], ErrorType?) -> ()) {
        
        let urlString = Constants.ACTIVITIES_ROUTE_GOOGLE+"/Paris/bar"
        let url = URL(string: urlString)
        if url == nil { completion([], ErrorType.badUrl) }
        let request = URLRequest(url: url!)
        
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
            let response = try decoder.decode([Activity].self, from: data)
            completion(response, nil)
        } catch let errorJson {
            completion([], ErrorType.serverError)
            print(errorJson)
            return
        }
        
        }.resume()
    }
}

