//
//  HomeWidgetModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public enum HomeWidgetIdentifier : String, Codable {
    case header = "HOME_HEADER_WIDGET"
    case card = "HOME_CARD_WIDGET"
    case statement = "HOME_STATEMENT_WIDGET"
    case notMapped
}

public enum ButtonActionIdentifier : String, Codable {
    case cardScreen = "CARD_SCREEN"
    case statementScreen = "STATEMENT_SCREEN"
}

public struct HomeWidget {
    var identifier: HomeWidgetIdentifier
    var content: Content
    
    public struct Content : Codable {
        var title : String
        var cardNumber : String?
        var balance : StatementBalance?
        var button : Button?
        
        public struct StatementBalance : Codable {
            var label : String
            var value : String
        }
        
        public struct Button : Codable {
            var text : String
            var action : Action
            
            struct Action : Codable {
                var identifier : ButtonActionIdentifier
                var content : Content
                
                struct Content : Codable {
                    var accountId : String?
                    var cardId : String?
                }
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case content
    }
}

extension HomeWidget : Decodable {
    public init(from decoder: Decoder) throws {
        let widget = try decoder.container(keyedBy: CodingKeys.self)
        let ident = try widget.decode(String.self, forKey: .identifier)
        content = try widget.decode(Content.self, forKey: .content)
        
        switch ident {
        case HomeWidgetIdentifier.header.rawValue:
            identifier = HomeWidgetIdentifier.header
        case HomeWidgetIdentifier.card.rawValue:
            identifier = HomeWidgetIdentifier.card
        case HomeWidgetIdentifier.statement.rawValue:
            identifier = HomeWidgetIdentifier.statement
        default:
            identifier = HomeWidgetIdentifier.notMapped
        }
    }
}

extension HomeWidget : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier.rawValue, forKey: .identifier)
        try container.encode(content, forKey: .content)
    }
}

public struct HomeResponse : Decodable {
    var widgets = [HomeWidget]()
}
