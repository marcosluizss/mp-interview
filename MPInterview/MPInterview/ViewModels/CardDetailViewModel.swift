//
//  CardViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class CardDetailViewModel {
    
    init(id: String? = nil) {
        if let id = id {
            cardId = id
        }
    }
    var cardId : String = ""
    var card : CardDetailModel?
}

extension CardDetailViewModel {
    func fetchCardDetail(completion: @escaping (Result<CardDetailModel, Error>) -> Void){
        let urlPath =  "\(baseUrl)\(cardUrlPath)/\(cardId)"
        //print(urlPath)
        HTTPService.shared.get(urlPath: urlPath, completionBlock: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    print("failure", error)
                case .success(let data):
                    let decoder = JSONDecoder()
                    do{
                        let cardDetail = try decoder.decode(CardDetailModel.self, from: data)
                        self.card = cardDetail
                        completion(.success(cardDetail))
                        
                    }catch {
                        print("Unexpected error: \(error).")
                    }
            }
        })
    }
}
