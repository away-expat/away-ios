//
//  UserService.swift
//  Away
//
//  Created by Candice Guitton on 19/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class UserService {
    
    func getConnectedUser(token: String, completion: @escaping (User?, ErrorType?) -> ()) {
        
        let urlString = Constants.GET_CONNECTED_USER
        let url = URL(string: urlString)
        if url == nil { completion(nil, ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 401) {
                    completion(nil, ErrorType.unauthorized)
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(User.self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion(nil, ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
}

