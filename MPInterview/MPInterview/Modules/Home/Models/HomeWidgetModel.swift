//
//  WidgetsModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

enum homeWidgetType : String, Codable {
    case header = "HOME_HEADER_WIDGET"
    case card = "HOME_CARD_WIDGET"
    case statement = "HOME_STATEMENT_WIDGET"
}

public struct HomeWidget : Codable {
    var identifier: homeWidgetType
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
                var identifier : String
                var content : Content
                
                struct Content : Codable {
                    var accountId : String?
                    var cardId : String?
                }
            }
        }
    }
    
}


public struct HomeResponse : Decodable {
    var widgets = [HomeWidget]()
}
    

