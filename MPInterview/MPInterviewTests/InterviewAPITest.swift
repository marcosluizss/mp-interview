//
//  InterviewAPITest.swift
//  MPInterviewTests
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import XCTest

@testable import MPInterview

class InterviewAPITest: XCTestCase {

    var httpClient : HTTPClient!
    var interviewAPI : InterviewAPI!
    var expectation: XCTestExpectation!
    
    let homeUrl = URL(string: baseUrl + homeUrlPath)!
    let cardUrlString = baseUrl + cardUrlPath
    let statementUrlString = baseUrl + statementUrlPath
    
    override func setUp(){
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        httpClient = HTTPClient.init(session: urlSession)
        expectation = expectation(description: "Expectation")
        interviewAPI = InterviewAPI.init(httpClient: httpClient)
    }
    
    ///
    func testFetchHomeWidgetsSucessful(){
        
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
            guard let url = request.url, url == self.homeUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchHomeWidgets(completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(let widgets):
                    XCTAssertEqual(widgets.count,3)
                    XCTAssertEqual(widgets[0].identifier,HomeWidgetIdentifier.header)
                    XCTAssertEqual(widgets[1].identifier,HomeWidgetIdentifier.card)
                    XCTAssertEqual(widgets[2].identifier,HomeWidgetIdentifier.statement)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
        
    }
    
    /// Teste da function
    /// FetchHomeWidgets
    ///
    func testFetchHomeWidgetsNoOneWidget(){
        
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
            guard let url = request.url, url == self.homeUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchHomeWidgets(completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(let widgets):
                    XCTAssertEqual(widgets.count,2)
                    XCTAssertEqual(widgets[0].identifier,HomeWidgetIdentifier.header)
                    XCTAssertEqual(widgets[1].identifier,HomeWidgetIdentifier.statement)
                    
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
            guard let url = request.url, url == self.homeUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchHomeWidgets(completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(let widgets):
                    XCTAssertEqual(widgets.count,4)
                    XCTAssertEqual(widgets[3].identifier,HomeWidgetIdentifier.notMapped)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
        
    }
    
    func testFetchHomeWidgetsWithError500(){
        
        let jsonString = "Server unavailable"
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == self.homeUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchHomeWidgets(completion: { (result) in
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
            guard let url = request.url, url == self.homeUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchHomeWidgets(completion: { (result) in
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
        let cardId = "123"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(cardId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchCreditCard(cardId: cardId, completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(let card):
                    XCTAssertEqual(card.cardName,cardName)
                    XCTAssertEqual(card.totalLimit,totalLimit)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    ///
    func testFetchCreditCardWithError500(){
        
        let jsonString = "Server unavialablr"
        
        let cardId = "123"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(cardId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchCreditCard(cardId: cardId, completion: { (result) in
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
        
        let cardId = "123"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(cardId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchCreditCard(cardId:cardId,completion: { (result) in
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
        
        let cardId = "1234"
        let cardUrl = URL(string: "\(self.cardUrlString)/\(cardId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == cardUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 400, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchCreditCard(cardId:cardId,completion: { (result) in
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
    
    /// Teste da function
    /// fetchAccountStatement
    ///
    
    func testFetchAccountStatementSucessful(){
        
        let balaceValue = "R$ 50.000,00"
        let secondTransactionValue = "- R$ 645,00"
        
        let jsonString = """
                        {
                            "balance": {
                                "label": "Saldo disponíevl",
                                "value": "\(balaceValue)"
                            },
                            "transactions": [
                                {
                                    "label": "Transferência enviada",
                                    "value": "- R$ 500,00",
                                    "description": "Teste fulano ciclano"
                                },
                                {
                                    "label": "Pagamento realizado",
                                    "value": "\(secondTransactionValue)",
                                    "description": "Teste fulano ciclano"
                                },
                                {
                                    "label": "Transferência recebida",
                                    "value": "+ R$ 2000,00",
                                    "description": "Movile Pay"
                                }
                            ]
                        }
        """
        
        let accountId = "123"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(accountId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchAccountStatement(accountId: accountId, completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(let statement):
                    XCTAssertEqual(statement.balance.value,balaceValue)
                    XCTAssertEqual(statement.transactions[1].value,secondTransactionValue)
                    XCTAssertEqual(statement.transactions.count,3)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    ///
    func testFetchAccountStatementWithError500(){
        
        let jsonString = "Server unavialable"
        
        let accountId = "123"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(accountId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchAccountStatement(accountId: accountId, completion: { (result) in
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
    
    
    func testFetchAccountStatementWithParserError(){
        
        let jsonString = """
                    {"teste" : "Erro Parsing"}
        """
        
        let accountId = "123"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(accountId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchAccountStatement(accountId: accountId, completion: { (result) in
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
    
    func testFetchAccountStatementWithNotValidAccountId(){
        
        let msgError = "Serviço indisponível."
        let jsonString = """
                    {"error" : { "title" : "\(msgError)" }}
        """
        
        let accountId = "1234"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(accountId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: self.homeUrl, statusCode: 400, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        interviewAPI.fetchAccountStatement(accountId: accountId, completion: { (result) in
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
}
