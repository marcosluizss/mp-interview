//
//  HTTPServiceTests.swift
//  MPInterviewTests
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import XCTest

@testable import MPInterview

class HTTPClientTests: XCTestCase {

    var httpClient : HTTPClient!
    var expectation: XCTestExpectation!
    var urlTest  = URL(string: baseUrl)!
    
    override func setUp(){
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        httpClient = HTTPClient.init(session: urlSession)
        expectation = expectation(description: "Expectation")
        
    }
    
    func testSuccessfulResponse(){
        
        let jsonString = """
                        {
                        "widgets": [
                            {
                                "identifier": "HOME_HEADER_WIDGET",
                                "content": {
                                    "title": "Olá Fulano!"
                                }
                            },
                            ]
                        }
        """
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.urlTest else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.urlTest, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        httpClient.get(urlPath: baseUrl){ (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Correto é retornar sucesso. Erro: \(error) ")
                case .success(let data):
                    XCTAssertEqual(String(decoding: data, as: UTF8.self),jsonString)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testServer500Response(){
        
        let jsonString = """
                        {
                        "widgets": [
                            {
                                "identifier": "HOME_HEADER_WIDGET",
                                "content": {
                                    "title": "Olá Fulano!"
                                }
                            }
                        ]
                    }
        """
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.urlTest else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.urlTest, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        httpClient.get(urlPath: baseUrl){ (result) in
            switch result {
            case .failure(let error):
                guard let error = error as? HTTPError else {
                    XCTFail("Erro retornado incorreto")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertNotNil(error)
            case .success( _):
                XCTFail("Falha. Retorno é 500 correto é retonar erro")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
    
    func testeWithBlankResponse(){
        
        let jsonString = ""
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.urlTest else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.urlTest, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        httpClient.get(urlPath: baseUrl){ (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Correto é retornar sucesso. Erro: \(error) ")
                case .success(let data):
                    XCTAssertEqual(String(decoding: data, as: UTF8.self),jsonString)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
    }
}

