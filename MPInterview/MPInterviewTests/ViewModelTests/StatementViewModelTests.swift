//
//  StatementViewModelTests.swift
//  MPInterviewTests
//
//  Created by Marcos Luiz on 29/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import XCTest

@testable import MPInterview

class StatementViewModelTests: XCTestCase {

    var httpClient : HTTPClient!
    var interviewAPI : InterviewAPI!
    var statementViewModel : StatementViewModel!
    var expectation: XCTestExpectation!
    
    let statementUrlString = baseUrl + statementUrlPath
    
    override func setUp(){
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        httpClient = HTTPClient.init(session: urlSession)
        expectation = expectation(description: "Expectation")
        interviewAPI = InterviewAPI.init(httpClient: httpClient)
        statementViewModel = StatementViewModel.init(accountId: nil, interviewAPI: interviewAPI)
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
        
        statementViewModel.accountId = "123"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(statementViewModel.accountId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        statementViewModel.fetchStatement(completion: { (result) in
            switch result {
                case .failure(let error):
                    XCTFail("Falha. Deveria retornar sucesso e não erro. Erro retornado: \(error)")
                case .success(_):
                    XCTAssertEqual(self.statementViewModel.statement?.balance.value,balaceValue)
                    XCTAssertEqual(self.statementViewModel.statement?.transactions[1].value,secondTransactionValue)
                    XCTAssertEqual(self.statementViewModel.statement?.transactions.count,3)
                    
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
        
    }
    
    ///
    func testFetchAccountStatementWithError500(){
        
        let jsonString = "Server unavialable"
        
        statementViewModel.accountId = "123"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(statementViewModel.accountId)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        statementViewModel.fetchStatement(completion: { (result) in
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
        
        statementViewModel.accountId = "123"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(statementViewModel.accountId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        statementViewModel.fetchStatement(completion: { (result) in
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
        
        statementViewModel.accountId = "1234"
        let statementUrl = URL(string: "\(self.statementUrlString)/\(statementViewModel.accountId!)")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        statementViewModel.fetchStatement(completion: { (result) in
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
    
    func testFetchAccountStatementWithNotAccountId(){
        
        let jsonString = "Server error"
        
        let statementUrl = URL(string: "\(self.statementUrlString)/")
        
        let data = jsonString.data(using: .utf8)
        
        MockUrlProtocol.requestHandler = { request in
            guard let url = request.url, url == statementUrl else {
                throw HTTPError.invalidURL
            }
            
            let response = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
            
            return (response,data)
        }
        
        statementViewModel.fetchStatement(completion: { (result) in
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
