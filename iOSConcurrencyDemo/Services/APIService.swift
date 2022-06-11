//
//  APIService.swift
//  iOSConcurrencyDemo
//
//  Created by Brent Crowley on 11/6/2022.
//

import Foundation

struct APIService {
    
    let urlString: String
    
    func getJSON<Model: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                    completion: @escaping (Result<Model, APIError>) -> Void) {
        
        guard let url = URL(string: urlString) else { completion(.failure(.invalidURL)); return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { completion(.failure(.invalidResponseStatus)); return }
            
            guard error == nil else { completion(.failure(.dataTaskError)); return }
            
            guard let data = data else { completion(.failure(.corruptData)); return }

            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                
                let decodedJSON = try decoder.decode(Model.self , from: data)
                
                completion(.success(decodedJSON))
                
            } catch {
                completion(.failure(.decodingError))
            }
            
        }
        .resume()
        
    }
    
}

enum APIError: Error {
    
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
    
}
