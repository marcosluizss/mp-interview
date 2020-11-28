//
//  HomeStatementWidgetView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

public protocol HomeStatementProtocol {
    var title : String { get set }
    var balanceLabel : String { get set }
    var balanceValue : String { get set }
    var buttonText : String { get set }
    var buttonActionDelegate : HomeCardButtonDelegate { get set }
    var buttonAction : ButtonActionIdentifier { get set }
    var accountId : String { get set }
}

public class HomeStatementWidgetView : UIView {
    
    let homeCardView: HomeCardView
    public let statementData: HomeStatementProtocol
   
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .equalSpacing
        stack.spacing = 10
        return stack
    }()
    
    private lazy var balanceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var balanceValue : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(statementData: HomeStatementProtocol) {
        self.statementData = statementData
        self.homeCardView = HomeCardView(buttonDelegate: statementData.buttonActionDelegate, buttonPressValue:statementData.accountId, buttonAction: statementData.buttonAction)
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare() {
        self.homeCardView.titleLabel.text = statementData.title
        balanceLabel.text = statementData.balanceLabel
        balanceValue.text = statementData.balanceValue
        horizontalStack.addArrangedSubview(balanceLabel)
        horizontalStack.addArrangedSubview(balanceValue)
        self.homeCardView.content.addSubview(horizontalStack)
        self.homeCardView.actionButton.setTitle(statementData.buttonText, for: .normal)
        self.addSubview(self.homeCardView)
        createConstraints()
        homeCardView.prepare()
        
    }
    
    func createConstraints(){
        self.homeCardView.translatesAutoresizingMaskIntoConstraints = false
        self.homeCardView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.homeCardView.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        self.homeCardView.trailingAnchor.constraint(equalTo:self.trailingAnchor).isActive = true
        self.homeCardView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        
        self.horizontalStack.translatesAutoresizingMaskIntoConstraints = false	
    }
    
}

