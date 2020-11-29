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

open class HomeCardView: CardView {
    
    let buttonDelegate : HomeCardButtonDelegate
    let buttonPressValue : String
    let buttonAction : ButtonActionIdentifier
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
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
    
    lazy var contentButton : UIView = {
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
        self.add(titleLabel)
        self.add(content)
        self.contentButton.addSubview(actionButton)
        self.constraints()
        self.add(contentButton)
        
    }
    
    private func constraints(){
        self.contentButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        self.actionButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.actionButton.centerYAnchor.constraint(equalTo: self.contentButton.centerYAnchor).isActive = true
        self.actionButton.centerXAnchor.constraint(equalTo: self.contentButton.centerXAnchor).isActive = true
    }
        
}

extension HomeCardView {
    @objc func buttonPress(button:UIButton){
        buttonDelegate.didPressButton(button: button, value: buttonPressValue, action: buttonAction)
    }
}



