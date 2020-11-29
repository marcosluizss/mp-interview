//
//  HomeViewModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

class HomeViewModel {
    var widgets = [HomeWidget]()
}

extension HomeViewModel {
    func fetchWidgets(completion: @escaping (Result<[HomeWidget], Error>) -> Void){
        InterviewAPI.shared.fetchHomeWidgets(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .failure(let error):
                    print("failure", error)
                case .success(let widgets):
                    // retira os widgets não mapeados
                    self.widgets = widgets.filter({ $0.identifier != .notMapped })
                    completion(.success(self.widgets))
            }
        })
    }
}
