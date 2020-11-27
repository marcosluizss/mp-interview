//
//  HomeHeaderWidget.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//
import Foundation
import UIKit

public struct HomeHeaderWidgetUIModel {
    var title : String
}

class HomeHeaderWidgetCell : UITableViewCell {
    
    var headerWidget : HomeHeaderWidgetUIModel?{
        didSet{
            guard let header = headerWidget else { return }
            titleLabel.text = header.title
        }
    }
    
    private lazy var titleLabel : UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(titleLabel)
        createConstraints()
    }
    
    func createConstraints(){
        titleLabel.topAnchor.constraint(equalTo:self.contentView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant:40).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
}
