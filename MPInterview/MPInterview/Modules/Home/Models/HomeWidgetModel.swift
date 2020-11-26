//
//  Widgets.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

// header widget
public struct HeaderWidgetContent : Codable {
    let title : String
}

public struct HomeHeaderWidget : Codable {
    let identifier: String
    let content: HeaderWidgetContent
}

// card widget
public struct HomeCardWidget : Codable {
    let identifier: String
    let content: CardWidgetContent
}

public struct CardWidgetContent : Codable {
    let title : String
    let cardNumber : String
    let button : CardButton
}

public struct CardButton : Codable {
    let text : String
    let actionIdentifier : String
    let action : Action
    
    struct Action : Codable {
        let identifier : String
        let content : Content
        
        struct Content : Codable {
            let acountId : String
        }
    }
}

//statement widget
public struct HomeStatementWidget : Codable {
    let identifier: String
    let content: StatementWidgetContent
}

public struct StatementWidgetContent : Codable {
    let title : String
    let balance : StatementBalance
    let button : StatementButton
}

public struct StatementBalance : Codable {
    let label : String
    let value : String
}

public struct StatementButton : Codable {
    let text : String
    let actionIdentifier : String
    let action : Action
    
    struct Action : Codable {
        let identifier : String
        let content : Content
        
        struct Content : Codable {
            let acountId : String
        }
    }
}


