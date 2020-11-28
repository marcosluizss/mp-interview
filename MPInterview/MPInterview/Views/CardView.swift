//
//  CardView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

open class CardView: UIView {
    
    public lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
    
    open func add(_ view: UIView) {
        if self.stackView.superview == nil {
            self.addSubview(self.stackView)
            self.createConstraint()
        }
        self.stackView.addArrangedSubview(view)
        self.layoutIfNeeded()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red:200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createConstraint() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
}
