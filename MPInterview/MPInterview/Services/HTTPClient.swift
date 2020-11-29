//
//  HttpService.swift
//  MPInterview
//
//  Created by Marcos Luiz on 25/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation


protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

protocol URLSessionProtocol {
    func dataTask (
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession : URLSessionProtocol{}
extension URLSessionDataTask : URLSessionDataTaskProtocol{}


//enum para retorno de erros
public enum HTTPError : Error {
    case unavailableService
    case invalidURL
    case invalidResponse(Data?,URLResponse?)
}

class HTTPClient {
    static let shared: HTTPClient = HTTPClient()
    private let session : URLSession
    
    init(session: URLSession = .shared ){
        self.session = session
    }
    
    // função base para realização de get
    func get(urlPath: String, completionBlock: @escaping (Result<Data,Error>) -> Void ){
        
        guard let url = URL(string: urlPath) else {
            completionBlock(.failure(HTTPError.invalidURL))
            return
        }
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

            completionBlock(.success(data))
        }
        task.resume()
        
    }
}
