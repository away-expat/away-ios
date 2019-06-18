//
//  ActivityService.swift
//  Away
//
//  Created by Candice Guitton on 16/06/2019.
//  Copyright © 2019 Candice Guitton. All rights reserved.
//
import UIKit
class LoginService {
    
    func signIn(mail: String, password: String, completion: @escaping (String, ErrorType?) -> ()) {
        
        let urlString = Constants.SIGN_IN
        let url = URL(string: urlString)
        if url == nil { completion("", ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = [
            "mail": mail,
            "password": password
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
                    completion("", ErrorType.unauthorized)
                }
            }
            
            do {
                let json = JSONDecoder()
                let response = try json.decode(Token.self, from: data)
                print("The token is: " + response.token)
                completion(response.token, nil)
            } catch let errorJson {
                completion("", ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
    func signUp(firstname: String, lastname: String, mail: String, password: String, birth: String, country: String, idCity: Int, completion: @escaping (String, ErrorType?) -> ()) {
        
        let urlString = Constants.SIGN_UP
        let url = URL(string: urlString)
        if url == nil { completion("", ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters = [
            "firstname": firstname,
            "lastname": lastname,
            "mail": mail,
            "password": password,
            "birth": birth,
            "country": country,
            "idCity": idCity
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
                    completion("", ErrorType.unauthorized)
                }
            }
            
            do {
                let json = JSONDecoder()
                let response = try json.decode(Token.self, from: data)
                print("The token is: " + response.token)
                completion(response.token, nil)
            } catch let errorJson {
                completion("", ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
}

