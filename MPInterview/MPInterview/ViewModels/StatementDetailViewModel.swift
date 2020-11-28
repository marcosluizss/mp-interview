//
//  StatementDetailViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class StatementDetailViewModel {
    
    init(id: String? = nil) {
        if let id = id {
            accountId = id
        }
    }
    var accountId : String = ""
    var statement : StatementDetailModel?
}

extension StatementDetailViewModel {
    func fetchStatementDetail(completion: @escaping (Result<StatementDetailModel, Error>) -> Void){
        let urlPath =  "\(baseUrl)\(statementUrlPath)/\(accountId)"
        //print(urlPath)
        HTTPService.shared.get(urlPath: urlPath, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    print("failure", error)
                case .success(let data):
                    let decoder = JSONDecoder()
                    do{
                        let statementDetail = try decoder.decode(StatementDetailModel.self, from: data)
                        self.statement = statementDetail
                        completion(.success(statementDetail))
                    }catch {
                        print("Unexpected error: \(error).")
                    }
            }
        })
    }
}
