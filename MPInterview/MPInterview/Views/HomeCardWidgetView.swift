//
//  HomeCardWidgetView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

public protocol HomeCardModelProtocol {
    var title : String { get set }
    var cardNumber : String { get set }
    var buttonText : String { get set }
    var buttonActionDelegate : HomeCardButtonDelegate { get set }
    var buttonAction : ButtonActionIdentifier { get set }
    var cardId : String { get set }
}

public class HomeCardWidgetView : UIView {
    
    public let homeCardView: HomeCardView
    public let cardModel: HomeCardModelProtocol
   
    private lazy var cardNumberLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(cardModel: HomeCardModelProtocol) {
        self.cardModel = cardModel
        self.homeCardView = HomeCardView(buttonDelegate: cardModel.buttonActionDelegate, buttonPressValue:cardModel.cardId, buttonAction: cardModel.buttonAction)
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare() {
        self.cardNumberLabel.text = cardModel.cardNumber
        //setando views do card
        self.homeCardView.titleLabel.text = cardModel.title
        self.homeCardView.content.addSubview(cardNumberLabel)
        self.homeCardView.actionButton.setTitle(cardModel.buttonText, for: .normal)
        //adicionando na view
        self.addSubview(self.homeCardView)
        //constraints
        createConstraints()
        //exibindo
        homeCardView.prepare()
    }
    
    func createConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.homeCardView.translatesAutoresizingMaskIntoConstraints = false
        self.homeCardView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.homeCardView.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        self.homeCardView.trailingAnchor.constraint(equalTo:self.trailingAnchor).isActive = true
        self.homeCardView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        
        self.cardNumberLabel.leadingAnchor.constraint(equalTo:self.homeCardView.content.leadingAnchor).isActive = true
        self.cardNumberLabel.trailingAnchor.constraint(equalTo:self.homeCardView.content.trailingAnchor).isActive = true
    }
    
}

