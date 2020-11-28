//
//  HomeStatementWidgetUIModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public struct HomeStatementWidgetUIModel : HomeStatementProtocol {    
    public var balanceLabel: String
    public var balanceValue: String
    public var buttonText: String
    public var buttonActionDelegate: HomeCardButtonDelegate
    public var buttonAction: ButtonActionIdentifier
    public var accountId: String
    public var title : String
}
