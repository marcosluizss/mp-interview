//
//  CardViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class CardDetailViewModel {
    
    init(cardId: String? = nil) {
        if let id = cardId {
            self.cardId = id
        }
    }
    
    var cardId : String?
    var card : CreditCardModel?
}

enum CardDetailError : Error {
    case noCardId
}

extension CardDetailViewModel {
    func fetchCardDetail(completion: @escaping (Result<CreditCardModel, Error>) -> Void){
        guard let cardId = cardId else {
            completion(.failure(APIResponseError.requestIdInvalid))
            return
        }
        InterviewAPI.shared.fetchCreditCard(cardId: cardId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let creditCard):
                    // retira os widgets não mapeados
                    self.card = creditCard
                    completion(.success(self.card!))
            }
        })
   
    }
}
