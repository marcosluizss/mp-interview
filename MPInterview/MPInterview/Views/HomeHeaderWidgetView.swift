//
//  HomeHeaderWidgetView.swift
//  MPInterview
//
//  Created by Marcos Luiz on 29/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation
import UIKit

public protocol HomeHeaderModelProtocol {
    var title : String { get set }
}

public class HomeHeaderWidgetView : UIView {
    
    public let headerModel: HomeHeaderModelProtocol
   
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public init(headerModel: HomeHeaderModelProtocol) {
        self.headerModel = headerModel
        super.init(frame: .zero)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func prepare() {
        self.titleLabel.text = headerModel.title
        self.addSubview(self.titleLabel)
        //constraints
        createConstraints()
    }
    
    func createConstraints(){
        self.translatesAutoresizingMaskIntoConstraints = false

        self.titleLabel.topAnchor.constraint(equalTo:self.topAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo:self.leadingAnchor).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo:self.trailingAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo:self.bottomAnchor).isActive = true
    }
    
}
