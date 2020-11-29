//
//  CardDetailView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

open class CardDetailView: CardView {
    
    private lazy var cardNumber : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardName : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var expirationDate : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    public init(cardNumber: String, cardName: String, expirationDate: String) {
        super.init(frame: .zero)
        self.cardNumber.text = cardNumber
        self.cardName.text = cardName
        self.expirationDate.text = "Expiration \(expirationDate)"
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare() {
        self.add(cardNumber)
        self.add(cardName)
        self.add(expirationDate)
    }
        
}



