    //
    //  HomeViewModel.swift
    //  MPInterview
    //
    //  Created by Marcos Luiz on 26/11/20.
    //  Copyright © 2020 ml2s. All rights reserved.
    //

    import Foundation

    class HomeViewModel {
        
        init(model: [HomeWidget]? = nil){
            if let initModel = model {
                widgets = initModel
            }
        }
        
        var widgets = [HomeWidget]()
    }

    extension HomeViewModel {
        func fetchWidgets(completion: @escaping (Result<[HomeWidget], Error>) -> Void){
            HTTPService.shared.get(urlPath: baseUrl + homeUrlPath, completionBlock: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    print("failure", error)
                case .success(let data):
                    let decoder = JSONDecoder()
                    do{
                        let homeResponse = try decoder.decode(HomeResponse.self, from: data)
                        self.widgets = homeResponse.widgets
                    completion(.success(homeResponse.widgets))
                }catch {
                    print("Unexpected error: \(error).")
                }
            }
        })
    }
}
