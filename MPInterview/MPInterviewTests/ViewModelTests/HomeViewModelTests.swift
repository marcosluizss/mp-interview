//
//  HomeViewModelTests.swift
//  MPInterviewTests
//
//  Created by Marcos Luiz on 29/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import XCTest

@testable import MPInterview

class HomeViewModelTests: XCTestCase {

    var httpClient : HTTPClient!
    var interviewAPI : InterviewAPI!
    var homeViewModel : HomeViewModel!
    var expectation: XCTestExpectation!
    
    let homeBaseUrl = URL(string: baseUrl + homeUrlPath)!
    
    override func setUp(){
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        httpClient = HTTPClient.init(session: urlSession)
        expectation = expectation(description: "Expectation")
        interviewAPI = InterviewAPI.init(httpClient: httpClient)
        homeViewModel = HomeViewModel.init(interviewAPI: interviewAPI)
    }
    
    ///
    func testFetchWidgetsSucessful(){
        
        let jsonString = """
                        {
                            "widgets": [
                                {
                                    "identifier": "HOME_HEADER_WIDGET",
                                    "content": {
                                        "title": "Olá Fulano!"
                                    }
                                },
                                {
                                    "identifier": "HOME_CARD_WIDGET",
                                    "content": {
                                        "title": "Meu cartão",
                                        "cardNumber": "•••• •••• •••• 8765",
                                        "button": {
                                            "text": "Ver detalhes",
                                            "action": {
                                                "identifier": "CARD_SCREEN",
                                                "content": {
                                                    "cardId": "123"
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    "identifier": "HOME_STATEMENT_WIDGET",
                                    "content": {
                                        "title": "Meu saldo",
                                        "balance": {
                                            "label": "Saldo disponíevl",
                                            "value": "R$ 50.000,00"
                                        },
                                        "button": {
                                            "text": "Ver extrato",
                                            "action": {
                                                "identifier": "STATEMENT_SCREEN",
                                                "content": {
                                                    "accountId": "123"
                                                }
                                            }
                                        }
                                    }
                                }
                            ]
                        }
        """
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.homeBaseUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        homeViewModel.fetchWidgets(completion: {(result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(_):
                    XCTAssertEqual(self.homeViewModel.widgets.count,3)
                    XCTAssertEqual(self.homeViewModel.widgets[0].identifier,HomeWidgetIdentifier.header)
                    XCTAssertEqual(self.homeViewModel.widgets[1].identifier,HomeWidgetIdentifier.card)
                    XCTAssertEqual(self.homeViewModel.widgets[2].identifier,HomeWidgetIdentifier.statement)
            }
        
            self.expectation.fulfill()
        })

        wait(for: [expectation], timeout: 5.0)
        
        
    }
    
    /// Teste da function
    /// FetchHomeWidgets
    ///
    func testFetchWidgetsNoOneWidget(){
        
        let jsonString = """
                        {
                            "widgets": [
                                {
                                    "identifier": "HOME_HEADER_WIDGET",
                                    "content": {
                                        "title": "Olá Fulano!"
                                    }
                                },
                                {
                                    "identifier": "HOME_STATEMENT_WIDGET",
                                    "content": {
                                        "title": "Meu saldo",
                                        "balance": {
                                            "label": "Saldo disponíevl",
                                            "value": "R$ 50.000,00"
                                        },
                                        "button": {
                                            "text": "Ver extrato",
                                            "action": {
                                                "identifier": "STATEMENT_SCREEN",
                                                "content": {
                                                    "accountId": "123"
                                                }
                                            }
                                        }
                                    }
                                }
                            ]
                        }
        """
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.homeBaseUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        homeViewModel.fetchWidgets(completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(_):
                    XCTAssertEqual(self.homeViewModel.widgets.count,2)
                    XCTAssertEqual(self.homeViewModel.widgets[0].identifier,HomeWidgetIdentifier.header)
                    XCTAssertEqual(self.homeViewModel.widgets[1].identifier,HomeWidgetIdentifier.statement)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    
    }
    
    func testFetchHomeWidgetsWithNotMappedWidget(){
        
        let jsonString = """
                        {
                            "widgets": [
                                {
                                    "identifier": "HOME_HEADER_WIDGET",
                                    "content": {
                                        "title": "Olá Fulano!"
                                    }
                                },
                                {
                                    "identifier": "HOME_CARD_WIDGET",
                                    "content": {
                                        "title": "Meu cartão",
                                        "cardNumber": "•••• •••• •••• 8765",
                                        "button": {
                                            "text": "Ver detalhes",
                                            "action": {
                                                "identifier": "CARD_SCREEN",
                                                "content": {
                                                    "cardId": "123"
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    "identifier": "HOME_STATEMENT_WIDGET",
                                    "content": {
                                        "title": "Meu saldo",
                                        "balance": {
                                            "label": "Saldo disponíevl",
                                            "value": "R$ 50.000,00"
                                        },
                                        "button": {
                                            "text": "Ver extrato",
                                            "action": {
                                                "identifier": "STATEMENT_SCREEN",
                                                "content": {
                                                    "accountId": "123"
                                                }
                                            }
                                        }
                                    }
                                },
                                {
                                    "identifier": "NOT_MAPPED",
                                    "content": {
                                        "title": "Teste",
                                        "slide": [
                                            { "test" : 1 },
                                            { "test" : 2 },
                                            { "test" : 3 }
                                        ]
                                    }
                                }
                            ]
                        }
        """
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.homeBaseUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        homeViewModel.fetchWidgets(completion: {(result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(_):
                    XCTAssertEqual(self.homeViewModel.widgets.count,3)
                    XCTAssertEqual(self.homeViewModel.widgets.filter({ $0.identifier == .notMapped }).count,0)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
        
    }
    
    func testFetchHomeWidgetsWithError500(){
        
        let jsonString = "Server unavailable"
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.homeBaseUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        homeViewModel.fetchWidgets(completion: {(result) in
            switch result {
                case .failure(let error):
                    guard let error = error as? APIResponseError else {
                        XCTFail("Erro retornado incorreto")
                        self.expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(error,APIResponseError.network)
                case .success(_):
                    XCTFail("Falha. Retorno é erro 500 não pode ter sucesso")
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testFetchHomeWidgetsWithParserError(){
        
        let jsonString = """
                    {"teste" : "Erro Parsing"}
        """
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.homeBaseUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        homeViewModel.fetchWidgets(completion: {(result) in
            switch result {
                case .failure(let error):
                    guard let error = error as? APIResponseError else {
                        XCTFail("Erro retornado incorreto")
                        self.expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(error,APIResponseError.jsonParse)
                case .success(_):
                    XCTFail("Falha. Retorno é erro 500 não pode ter sucesso")
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)

    }

}
