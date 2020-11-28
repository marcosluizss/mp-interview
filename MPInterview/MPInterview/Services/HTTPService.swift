//
//  HttpService.swift
//  MPInterview
//
//  Created by Marcos Luiz on 25/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
	
class HTTPService {
    static let shared: HTTPService = HTTPService()
    
    //enum para retorno de erros
    enum HTTPError : Error {
        case unavailableService
        case invalidURL
        case invalidResponse(Data?,URLResponse?)
    }
    
    // função base para realização de get
    func get(urlPath: String, completionBlock: @escaping (Result<Data,Error>) -> Void ){
        
        guard let url = URL(string: urlPath) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (responseData : Data?, urlResponse: URLResponse?, error: Error?) in
            guard error == nil else {
                completionBlock(.failure(error!))
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200, let data = responseData else {
                completionBlock(.failure(HTTPError.invalidResponse(responseData, urlResponse)))
                return
            }
            //print(String(decoding: data, as: UTF8.self))
            completionBlock(.success(data))
        }
        task.resume()
        
    }
}
