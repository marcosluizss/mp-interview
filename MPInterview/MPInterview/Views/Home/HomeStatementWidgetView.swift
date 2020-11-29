//
//  HomeStatementWidgetView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

public protocol HomeStatementModelProtocol {
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
    public let statementModel: HomeStatementModelProtocol
    
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
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var balanceValue : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(statementModel: HomeStatementModelProtocol) {
        self.statementModel = statementModel
        self.homeCardView = HomeCardView(buttonDelegate: statementModel.buttonActionDelegate, buttonPressValue:statementModel.accountId, buttonAction: statementModel.buttonAction)
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare() {
        self.homeCardView.titleLabel.text = statementModel.title
        balanceLabel.text = statementModel.balanceLabel
        balanceValue.text = statementModel.balanceValue
        horizontalStack.addArrangedSubview(balanceLabel)
        horizontalStack.addArrangedSubview(balanceValue)
        self.homeCardView.content.addSubview(horizontalStack)
        self.homeCardView.actionButton.setTitle(statementModel.buttonText, for: .normal)
        self.addSubview(self.homeCardView)
        createConstraints()
        homeCardView.prepare()
        
    }
    
    func createConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.homeCardView.translatesAutoresizingMaskIntoConstraints = false
        self.homeCardView.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.homeCardView.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        self.homeCardView.trailingAnchor.constraint(equalTo:self.trailingAnchor).isActive = true
        self.homeCardView.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
        
        self.horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStack.leadingAnchor.constraint(equalTo:self.homeCardView.content.leadingAnchor).isActive = true
        self.horizontalStack.trailingAnchor.constraint(equalTo:self.homeCardView.content.trailingAnchor).isActive = true
    }
    
}

