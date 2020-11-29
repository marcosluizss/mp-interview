//
//  HTTPMock.swift
//  MPInterviewTests
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class MockUrlProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading(){
        guard let handler = MockUrlProtocol.requestHandler else {
            fatalError("Handler is unavailable")
        }
        
        do{
            let (response,data) = try handler(request)
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                client?.urlProtocol(self,didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading(){
        
    }
}
