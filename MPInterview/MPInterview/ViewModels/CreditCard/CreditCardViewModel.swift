//
//  CardViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class CreditCardViewModel {
    var cardId : String?
    var card : CreditCardModel?
    
    private let interviewAPI : InterviewAPI
    
    init(cardId: String? = nil, interviewAPI: InterviewAPI = .shared) {
        if let id = cardId {
            self.cardId = id
        }
        self.interviewAPI = interviewAPI
    }
    
}

extension CreditCardViewModel {
    func fetchCard(completion: @escaping (Result<Bool, Error>) -> Void){
        guard let cardId = cardId else {
            completion(.failure(APIResponseError.requestIdInvalid))
            return
        }
        interviewAPI.fetchCreditCard(cardId: cardId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let creditCard):
                    // retira os widgets não mapeados
                    self.card = creditCard
                    completion(.success(true))
            }
        })
   
    }
}
