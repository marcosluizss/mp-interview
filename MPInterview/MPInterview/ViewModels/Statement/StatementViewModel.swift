//
//  StatementDetailViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class StatementViewModel {
    
    var accountId : String?
    var statement : StatementModel?
    
    private let interviewAPI : InterviewAPI
    
    init(accountId: String? = nil, interviewAPI: InterviewAPI = .shared) {
        if let id = accountId {
            self.accountId = id
        }
        self.interviewAPI = interviewAPI
    }
    
}

extension StatementViewModel {
    func fetchStatement(completion: @escaping (Result<Bool, Error>) -> Void){
        guard let accountId = accountId else {
            completion(.failure(APIResponseError.requestIdInvalid))
            return
        }
        interviewAPI.fetchAccountStatement(accountId: accountId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let statement):
                    // retira os widgets não mapeados
                    self.statement = statement
                    completion(.success(true))
            }
        })
        
    }
}
