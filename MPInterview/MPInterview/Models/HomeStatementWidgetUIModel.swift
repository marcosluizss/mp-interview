//
//  HomeStatementWidgetUIModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public struct HomeStatementWidgetUIModel : HomeStatementModelProtocol {    
    public var balanceLabel: String
    public var balanceValue: String
    public var buttonText: String
    public var buttonActionDelegate: HomeCardButtonDelegate
    public var buttonAction: ButtonActionIdentifier
    public var accountId: String
    public var title : String
}

extension HomeStatementWidgetUIModel {
    static func fromHomeWidget(homeWidget: HomeWidget, buttonDelegate buttonActionDelegate : HomeCardButtonDelegate) -> HomeStatementWidgetUIModel? {
        
        let title = homeWidget.content.title
        guard let accountId = homeWidget.content.button?.action.content.accountId else {
            return nil
        }
        guard let buttonText = homeWidget.content.button?.text else {
            return nil
        }
        guard let buttonAction = homeWidget.content.button?.action.identifier else {
            return nil
        }
        guard let balanceValue = homeWidget.content.balance?.value else {
            return nil
        }
        guard let balanceLabel = homeWidget.content.balance?.label  else {
            return nil
        }
      
        return HomeStatementWidgetUIModel(balanceLabel: balanceLabel, balanceValue: balanceValue, buttonText: buttonText, buttonActionDelegate: buttonActionDelegate, buttonAction: buttonAction, accountId: accountId, title: title  )
    }
}
