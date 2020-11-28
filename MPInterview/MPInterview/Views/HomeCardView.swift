//
//  HomeCardBoxView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

public protocol HomeCardButtonDelegate {
    func didPressButton(button: UIButton, value: String, action: ButtonActionIdentifier)
}

open class HomeCardView: UIView {
    
    let buttonDelegate : HomeCardButtonDelegate
    let buttonPressValue : String
    let buttonAction : ButtonActionIdentifier
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 25
        return stack
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.tintColor = .black
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var content : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public init(buttonDelegate: HomeCardButtonDelegate, buttonPressValue : String, buttonAction: ButtonActionIdentifier) {
        self.buttonDelegate = buttonDelegate
        self.buttonPressValue = buttonPressValue
        self.buttonAction = buttonAction
        super.init(frame: .zero)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare() {
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(content)
        self.stackView.addArrangedSubview(actionButton)
        self.addSubview(self.stackView)
        self.createConstraint()
    }

    private func createConstraint() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true

        
    }
    
}

extension HomeCardView {
    @objc func buttonPress(button:UIButton){
        buttonDelegate.didPressButton(button: button, value: buttonPressValue, action: buttonAction)
    }
}



