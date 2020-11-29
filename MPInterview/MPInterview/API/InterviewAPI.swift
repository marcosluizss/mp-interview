//
//  InterviewAPI.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

enum APIResponseError : Error, Equatable {
    case jsonParse
    case network
    case messageError(String)
    case requestIdInvalid
}

struct ServerResponseError : Codable {
    var error : ErrorDescription
    
    struct ErrorDescription : Codable {
        var title : String
    }
    
}

class InterviewAPI {
    
    static let shared: InterviewAPI = InterviewAPI()
    private let httpClient : HTTPClient
    
    init(httpClient: HTTPClient = .shared ){
        self.httpClient = httpClient
    }
    
    // buscar widgets da home
    func fetchHomeWidgets(completion: @escaping (Result<[HomeWidget], Error>) -> Void){
        httpClient.get(urlPath: baseUrl + homeUrlPath, completionBlock: { result in
            switch result {
                case .failure(let error):
                    do {
                    guard let error = error as? HTTPError else {
                        throw APIResponseError.network
                    }
                    var  msgError = ""
                    switch error {
                    case .invalidURL:
                        msgError = "Falha na URL informada"
                    case .unavailableService:
                        msgError = "Falha no servidor"
                    case .invalidResponse(let data, let response):
                        let decoder = JSONDecoder()
                        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 400 {
                            let responseError = try decoder.decode(ServerResponseError.self, from: data)
                            throw APIResponseError.messageError(responseError.error.title)
                        }
                        
                        throw APIResponseError.network
                    }
                    
                        throw APIResponseError.messageError(msgError)
                    
                    } catch {
                        completion(.failure(error))
                    }
                case .success(let data):
                    let decoder = JSONDecoder()
                    do{
                        let homeResponse = try decoder.decode(HomeResponse.self, from: data)
                        completion(.success(homeResponse.widgets))
                    }catch {
                        do {
                            let responseError = try decoder.decode(ServerResponseError.self, from: data)
                            completion(.failure(APIResponseError.messageError(responseError.error.title)))
                        }catch{
                            completion(.failure(APIResponseError.jsonParse))
                            
                        }
                    }
            }
        })
    }
    
    // buscar detalhes do cartão de crédito
    func fetchCreditCard(cardId: String, completion: @escaping (Result<CreditCardModel, Error>) -> Void){
        let urlPath =  "\(baseUrl)\(cardUrlPath)/\(cardId)"
        
        httpClient.get(urlPath: urlPath, completionBlock: { result in
            
            switch result {
                case .failure(let error):
                    do {
                    guard let error = error as? HTTPError else {
                        throw APIResponseError.network
                    }
                    var  msgError = ""
                    switch error {
                    case .invalidURL:
                        msgError = "Falha na URL informada"
                    case .unavailableService:
                        msgError = "Falha no servidor"
                    case .invalidResponse(let data, let response):
                        let decoder = JSONDecoder()
                        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 400 {
                            let responseError = try decoder.decode(ServerResponseError.self, from: data)
                            throw APIResponseError.messageError(responseError.error.title)
                        }
                        
                        throw APIResponseError.network
                    }
                    
                        throw APIResponseError.messageError(msgError)
                    
                    } catch {
                        completion(.failure(error))
                    }
                case .success(let data):
                    let decoder = JSONDecoder()
                    do{
                        let cardDetail = try decoder.decode(CreditCardModel.self, from: data)
                        completion(.success(cardDetail))
                    }catch {
                        completion(.failure(APIResponseError.jsonParse))
                    }
            }
        })
    }
    
    // buscar detalhes do extrato
    func fetchAccountStatement(accountId: String, completion: @escaping (Result<StatementModel, Error>) -> Void){
        let urlPath =  "\(baseUrl)\(statementUrlPath)/\(accountId)"
        
        httpClient.get(urlPath: urlPath, completionBlock: { result in
            switch result {
                case .failure(let error):
                    do {
                    guard let error = error as? HTTPError else {
                        throw APIResponseError.network
                    }
                    var  msgError = ""
                    switch error {
                    case .invalidURL:
                        msgError = "Falha na URL informada"
                    case .unavailableService:
                        msgError = "Falha no servidor"
                    case .invalidResponse(let data, let response):
                        let decoder = JSONDecoder()
                        if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 400 {
                            let responseError = try decoder.decode(ServerResponseError.self, from: data)
                            throw APIResponseError.messageError(responseError.error.title)
                        }
                        
                        throw APIResponseError.network
                    }
                    
                        throw APIResponseError.messageError(msgError)
                    
                    } catch {
                        completion(.failure(error))
                    }
                case .success(let data):
                    let decoder = JSONDecoder()
                    do{
                        let statementDetail = try decoder.decode(StatementModel.self, from: data)
                        completion(.success(statementDetail))
                    }catch {
                        do {
                            let responseError = try decoder.decode(ServerResponseError.self, from: data)
                            completion(.failure(APIResponseError.messageError(responseError.error.title)))
                        }catch{
                            completion(.failure(APIResponseError.jsonParse))
                            
                        }
                    }
            }
        })
    }
}
