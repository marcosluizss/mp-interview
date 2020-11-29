//
//  HomeCardWidgetUIModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public struct HomeCardWidgetUIModel : HomeCardModelProtocol {
    public var cardNumber: String
    public var buttonText: String
    public var buttonActionDelegate: HomeCardButtonDelegate
    public var buttonAction: ButtonActionIdentifier
    public var cardId: String
    public var title : String
}

extension HomeCardWidgetUIModel {
    static func fromHomeWidget(homeWidget: HomeWidget, buttonDelegate buttonActionDelegate : HomeCardButtonDelegate) -> HomeCardWidgetUIModel? {
        
        let title = homeWidget.content.title
        guard let cardId = homeWidget.content.button?.action.content.cardId else {
            return nil
        }
        guard let buttonText = homeWidget.content.button?.text else {
            return nil
        }
        guard let buttonAction = homeWidget.content.button?.action.identifier else {
            return nil
        }
        guard let cardNumber = homeWidget.content.cardNumber else {
            return nil
        }
    
        return HomeCardWidgetUIModel(cardNumber: cardNumber, buttonText: buttonText, buttonActionDelegate: buttonActionDelegate, buttonAction: buttonAction, cardId: cardId, title: title)
    }
}
