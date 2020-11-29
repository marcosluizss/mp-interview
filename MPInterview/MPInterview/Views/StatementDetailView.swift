//
//  StatementDetailView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit


class StatementCell : UITableViewCell {
    
    public lazy var label : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var value : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    public lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .top
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    public lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.verticalStackView.addArrangedSubview(label)
        self.verticalStackView.addArrangedSubview(descriptionLabel)
        self.horizontalStackView.addArrangedSubview(verticalStackView)
        self.horizontalStackView.addArrangedSubview(value)
        
        self.contentView.addSubview(horizontalStackView)
        
        self.constraints()
    }
    
    private func constraints(){
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


