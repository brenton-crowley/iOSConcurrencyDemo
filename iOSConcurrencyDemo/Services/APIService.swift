//
//  APIService.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import Foundation

struct APIService {
    
    let urlString: String
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return }
            
            guard error == nil else { return }
            
            guard let data = data else { return }

            
            let decoder = JSONDecoder()
            
            do {
                
                let json = try decoder.decode([User].self , from: data)
                
                completion(json)
                
            } catch {
                print("Error")
            }
            
        }
        .resume()
        
    }
    
}
