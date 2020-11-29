//
//  CardViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

class CreditCardViewController: BaseViewController {
    
    var cardDetailViewModel = CardDetailViewModel()
    let pageTitle  = "Cartão"
    
    private lazy var cardDetailView: CreditCardDetailView = {
        let cardNumber :String = cardDetailViewModel.card?.cardNumber ?? ""
        let cardName :String = cardDetailViewModel.card?.cardName ?? ""
        let expirationDate :String = cardDetailViewModel.card?.expirationDate ?? ""
        let card = CreditCardDetailView(cardNumber: cardNumber, cardName: cardName, expirationDate: expirationDate)
        return card
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private lazy var availableLimit : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        let availableLimit = cardDetailViewModel.card?.availableLimit ?? ""
        label.text = "Limite disponível: \(availableLimit)"
        return label
    }()
    
    private lazy var totalLimit : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        let totalLimit = cardDetailViewModel.card?.totalLimit ?? ""
        label.text = "Limite total: \(totalLimit)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        
        self.view.addSubview(stackView)
            
        cardDetailViewModel.fetchCardDetail { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.showCardData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    guard let error = error as? APIResponseError else {
                        return
                    }
                    switch error {
                    case .messageError(let msgError):
                        self?.loadErrorAlert(message: msgError)
                    default:
                        print("erro não mapeado")
                        self?.loadErrorAlert(message: "Desculpe. Tente novamente mais tarde")
                    }
                }
            }
            
        }
        
        createContraints()
    }
    
    private func showCardData(){
        self.stackView.addArrangedSubview(cardDetailView)
        self.stackView.addArrangedSubview(availableLimit)
        self.stackView.addArrangedSubview(totalLimit)
        cardDetailView.prepare()
    }
    
    private func createContraints(){
        let safeArea = view.layoutMarginsGuide
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        self.stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10).isActive = true
        self.stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true

    }
}

extension CreditCardViewController {
    private func loadErrorAlert(message : String){
        let dialogMessage = UIAlertController(title: "Não foi possível recuperar o cartão", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { ( action ) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
