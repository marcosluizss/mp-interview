//
//  StatementDetailViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class StatementViewModel {
    
    init(accountId: String? = nil) {
        if let id = accountId {
            self.accountId = id
        }
    }
    
    var accountId : String?
    var statement : StatementModel?
}

extension StatementViewModel {
    func fetchStatementDetail(completion: @escaping (Result<StatementModel, Error>) -> Void){
        guard let accountId = accountId else {
            completion(.failure(APIResponseError.requestIdInvalid))
            return
        }
        InterviewAPI.shared.fetchAccountStatement(accountId: accountId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let statement):
                    // retira os widgets não mapeados
                    self.statement = statement
                    completion(.success(self.statement!))
            }
        })
        
    }
}
