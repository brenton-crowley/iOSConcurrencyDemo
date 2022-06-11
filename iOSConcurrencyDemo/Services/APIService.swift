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
            
            guard error == nil else { completion(.failure(.dataTaskError(error!.localizedDescription))); return }
            
            guard let data = data else { completion(.failure(.corruptData)); return }

            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do {
                
                let decodedJSON = try decoder.decode(Model.self , from: data)
                
                completion(.success(decodedJSON))
                
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
            
        }
        .resume()
        
    }
    
}

enum APIError: Error, LocalizedError {
    
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response. Expected 200.", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt.", comment: "")
        case .decodingError(let string):
            return string
        }
        
    }
    
}
