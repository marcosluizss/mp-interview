//
//  HomeCardWidgetModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

// card widget
public struct HomeCardWidgetModel : Codable {
    let identifier: String
    let content: CardWidgetContent
    
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
}
