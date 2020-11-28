//
//  CardViewController.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

class CardDetailViewController: BaseViewController {
    
    var cardDetailViewModel = CardDetailViewModel()
    var cardId : String = ""
    let pageTitle  = "Cartão"
    
    private lazy var cardDetailView: CardDetailView = {
        let cardNumber :String = cardDetailViewModel.card?.cardNumber ?? ""
        let cardName :String = cardDetailViewModel.card?.cardName ?? ""
        let expirationDate :String = cardDetailViewModel.card?.expirationDate ?? ""
        let card = CardDetailView(cardNumber: cardNumber, cardName: cardName, expirationDate: expirationDate)
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        let availableLimit = cardDetailViewModel.card?.availableLimit ?? ""
        label.text = "Limite disponível: \(availableLimit)"
        return label
    }()
    
    private lazy var totalLimit : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        let totalLimit = cardDetailViewModel.card?.totalLimit ?? ""
        label.text = "Limite total: \(totalLimit)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        cardDetailViewModel.cardId = cardId
        
        self.view.addSubview(stackView)
            
        cardDetailViewModel.fetchCardDetail { [weak self] card in
            DispatchQueue.main.async {
                self?.showCardData()
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
