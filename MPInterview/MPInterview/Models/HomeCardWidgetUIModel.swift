//
//  HomeCardWidgetUIModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public struct HomeCardWidgetUIModel : HomeCardProtocol {
    public var cardNumber: String
    public var buttonText: String
    public var buttonActionDelegate: HomeCardButtonDelegate
    public var buttonAction: ButtonActionIdentifier
    public var cardId: String
    public var title : String
}
