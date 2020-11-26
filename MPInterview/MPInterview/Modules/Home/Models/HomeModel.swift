//
//  WidgetsModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public struct HomeResponse {
    let widgets: [HomeWidgetModel]
}

enum HomeWidgetModel {
    case header([HomeHeaderWidgetModel])
    case card([HomeCardWidgetModel])
    case statement([HomeStatementWidgetModel])
    case notDefined(String)
    
    enum identifier: String, Codable {
        case header = "HOME_HEADER_WIDGET"
        case card = "HOME_CARD_WIDGET"
        case statement = "HOME_STATEMENT_WIDGET"
        , notDefined
    }
}

extension HomeWidgetModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case identifier, widgets
    }
    
    // faz o decode de acordo com o tipo do widget passado no identfier
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let identifier = try container.decode(HomeWidgetModel.identifier.self, forKey: .identifier)
        switch identifier {
            case .header:
                let items = try container.decode([HomeHeaderWidgetModel].self, forKey: .widgets)
                self = .header(items)
            case .card:
                let items = try container.decode([HomeCardWidgetModel].self, forKey: .widgets)
                self = .card(items)
            case .statement:
                let items = try container.decode([HomeStatementWidgetModel].self, forKey: .widgets)
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
            try container.encode(HomeWidgetModel.identifier.header.rawValue, forKey: .identifier)
            try container.encode(attachment, forKey: .widgets)
        case .card(let attachment):
            try container.encode(HomeWidgetModel.identifier.card.rawValue, forKey: .identifier)
            try container.encode(attachment, forKey: .widgets)
        case .statement(let attachment):
            try container.encode(HomeWidgetModel.identifier.statement.rawValue, forKey: .identifier)
            try container.encode(attachment, forKey: .widgets)
        case .notDefined:
            print("encode: Widget não definido \(self)")
        }
    }

}

