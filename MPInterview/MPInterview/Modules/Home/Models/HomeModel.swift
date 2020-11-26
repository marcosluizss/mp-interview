//
//  WidgetsModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

enum HomeWidget {
    case header([HomeHeaderWidget])
    case card([HomeCardWidget])
    case statement([HomeStatementWidget])
    case notDefined(String)
    
    enum identifier: String, Codable {
        case header = "HOME_HEADER_WIDGET"
        case card = "HOME_CARD_WIDGET"
        case statement = "HOME_STATEMENT_WIDGET"
        , notDefined
    }
}

extension HomeWidget: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier, widgets
    }
    
    // faz o decode de acordo com o tipo do widget passado no identfier
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(HomeWidget.identifier.self, forKey: .identifier)
        switch identifier {
            case .header:
                let items = try container.decode([HomeHeaderWidget].self, forKey: .widgets)
                self = .header(items)
            case .card:
                let items = try container.decode([HomeCardWidget].self, forKey: .widgets)
                self = .card(items)
            case .statement:
                let items = try container.decode([HomeStatementWidget].self, forKey: .widgets)
                self = .statement(items)
            case .notDefined:
                print("decode: Widget não definido \(identifier)")
                self = .notDefined("")
        }
    }
    
    // faz o encode do struct de acordo com o tipo
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .header(let attachment):
            try container.encode(HomeWidget.identifier.header.rawValue, forKey: .identifier)
            try container.encode(attachment, forKey: .widgets)
        case .card(let attachment):
            try container.encode(HomeWidget.identifier.card.rawValue, forKey: .identifier)
            try container.encode(attachment, forKey: .widgets)
        case .statement(let attachment):
            try container.encode(HomeWidget.identifier.statement.rawValue, forKey: .identifier)
            try container.encode(attachment, forKey: .widgets)
        case .notDefined:
            print("encode: Widget não definido \(self)")
        }
    }

}

public struct HomeResponse {
    let widgets: [HomeWidget]
}
