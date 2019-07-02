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
    func getUsers(token: String, search: String, completion: @escaping ([User], ErrorType?) -> ()) {
        
        let urlString = Constants.SEARCH_USERS + search
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
                let response = try decoder.decode([User].self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion([], ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
    func getUserById(token: String, userId: Int, completion: @escaping (Profile?, ErrorType?) -> ()) {
        
        let urlString = Constants.GET_USER_BY_ID + userId.description
        let url = URL(string: urlString)
        if url == nil { completion(nil, ErrorType.badUrl) }
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
                    completion(nil, ErrorType.unauthorized)
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Profile.self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion(nil, ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
    func updateUserCity(token: String, cityId: Int, completion: @escaping (City?, ErrorType?) -> ()) {
        
        let urlString = Constants.UPDATE_CITY_USER + cityId.description
        let url = URL(string: urlString)
        if url == nil { completion(nil, ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
        print(request)
        
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
                let response = try decoder.decode(City.self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion(nil, ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }

    func updateUser(token: String, firstname: String, lastname: String, mail: String, password: String, birth: String, country: String, completion: @escaping (User?, ErrorType?) -> ()) {
        
        let urlString = Constants.UPDATE_USER
        let url = URL(string: urlString)
        if url == nil { completion(nil, ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        let parameters = [
            "firstname": firstname,
            "lastname": lastname,
            "mail": mail,
            "password": password,
            "birth": birth,
            "country": country
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
        print(jsonData)
        
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
                let response = try json.decode(User.self, from: data)
                completion(response, nil)
            } catch let errorJson {
                completion(nil, ErrorType.serverError)
                print(errorJson)
                return
            }
            
            }.resume()
    }
    
    
    func deleteAccount(token: String, completion: @escaping (ErrorType?) -> ()) {
        
       
        let urlString = Constants.DELETE_USER
        let url = URL(string: urlString)
        if url == nil { completion(ErrorType.badUrl) }
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let token = token
        request.setValue(token, forHTTPHeaderField: "Authorization")
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            
            if let httpResponse = response as? HTTPURLResponse {
                print("error \(httpResponse.statusCode)")
                if (httpResponse.statusCode == 401) {
                    completion(ErrorType.unauthorized)
                }
                if httpResponse.statusCode == 200 {
                    completion(ErrorType.ok)
                }
            }
           
            
            }.resume()
    }
}

