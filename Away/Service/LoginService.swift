//
//  ActivityService.swift
//  Away
//
//  Created by Candice Guitton on 16/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class LoginService {
    
    func signIn(completion: @escaping (String, ErrorType?) -> ()) {
        
        let urlString = Constants.SIGN_IN
        let url = URL(string: urlString)
        if url == nil { completion("", ErrorType.badUrl) }
        let request = URLRequest(url: url!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 401) {
                    completion("", ErrorType.unauthorized)
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Token.self, from: data)
                completion(response.token, nil)
            } catch let errorJson {
                completion("", ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
}

