//
//  HomeStatementWidgetModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

//statement widget
public struct HomeStatementWidgetModel : Codable {
    let identifier: String
    let content: StatementWidgetContent
    
    public struct StatementWidgetContent : Codable {
        let title : String
        let balance : StatementBalance
        let button : StatementButton
        
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
    }
    
}


