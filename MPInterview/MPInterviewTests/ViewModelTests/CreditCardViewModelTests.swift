//
//  CreditCardViewModelTests.swift
//  MPInterviewTests
//
//  Created by Marcos Luiz on 29/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import XCTest

@testable import MPInterview

class CreditCardViewModelTests: XCTestCase {

    var httpClient : HTTPClient!
    var interviewAPI : InterviewAPI!
    var creditCardViewModel : CreditCardViewModel!
    var expectation: XCTestExpectation!
    
    let cardUrlString = baseUrl + cardUrlPath
    
    override func setUp(){
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        httpClient = HTTPClient.init(session: urlSession)
        expectation = expectation(description: "Expectation")
        interviewAPI = InterviewAPI.init(httpClient: httpClient)
        creditCardViewModel = CreditCardViewModel(cardId: nil, interviewAPI: interviewAPI)
    }
    
    /// Teste da function
    /// fetchCreditCard
    ///
    
    func testFetchCreditCardSucessful(){
        
        let cardName = "Teste Fulano Ciclano"
        let totalLimit = "R$ 5.000,00"
        
        let jsonString = """
                        {
                            "cardNumber": "•••• •••• •••• 8765",
                            "cardName": "\(cardName)",
                            "expirationDate": "09/25",
                            "availableLimit": "R$ 3.000,00",
                            "totalLimit": "\(totalLimit)"
                        }
        """
        creditCardViewModel.cardId = "123"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(creditCardViewModel.cardId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        creditCardViewModel.fetchCard(completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(_):
                    XCTAssertEqual(self.creditCardViewModel.card?.cardName,cardName)
                    XCTAssertEqual(self.creditCardViewModel.card?.totalLimit,totalLimit)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    ///
    func testFetchCreditCardWithError500(){
        
        let jsonString = "Server unavialablr"
        
        creditCardViewModel.cardId = "123"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(creditCardViewModel.cardId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        creditCardViewModel.fetchCard(completion: { (result) in
            switch result {
                case .failure(let error):
                    guard let error = error as? APIResponseError else {
                        XCTFail("Erro retornado incorreto")
                        self.expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(error,APIResponseError.network)
                case .success(_):
                    XCTFail("Falha. Deveria retornar erro e não sucesso")
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    
    func testFetchCreditCardWithParserError(){
        
        let jsonString = """
                    {"teste" : "Erro Parsing"}
        """
        
        creditCardViewModel.cardId = "123"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(creditCardViewModel.cardId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        creditCardViewModel.fetchCard(completion: { (result) in
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
    
    func testFetchCreditCardWithInvalidCardId(){
        
        let msgError = "Cartão não encontrado"
        let jsonString = """
                    {"error" : { "title" : "\(msgError)" }}
        """
        
        creditCardViewModel.cardId = "1234"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(creditCardViewModel.cardId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        creditCardViewModel.fetchCard(completion: { (result) in
            switch result {
                case .failure(let error):
                    guard let error = error as? APIResponseError else {
                        XCTFail("Erro retornado incorreto")
                        self.expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(error,APIResponseError.messageError(msgError))
                case .success(_):
                    XCTFail("Falha. Retorno é erro 500 não pode ter sucesso")
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)

    }
    
    func testFetchCreditCardWithNoCardId(){
        
        let jsonString = "Server error"
        
        let cardUrl = URL(string: "\(self.cardUrlString)/")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        creditCardViewModel.fetchCard(completion: { (result) in
            switch result {
                case .failure(let error):
                    guard let error = error as? APIResponseError else {
                        XCTFail("Erro retornado incorreto")
                        self.expectation.fulfill()
                        return
                    }
                    
                    XCTAssertEqual(error,APIResponseError.requestIdInvalid)
                case .success(_):
                    XCTFail("Falha. Retorno é erro 500 não pode ter sucesso")
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)

    }

}
