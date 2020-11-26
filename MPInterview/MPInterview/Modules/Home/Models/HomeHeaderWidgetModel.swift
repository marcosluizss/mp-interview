//
//  Widgets.swift
//  MPInterview
//
//  Created by Marcos Luiz on 26/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

// header widget
 struct HomeHeaderWidgetModel : Codable {
    let identifier: String
    let content: HeaderWidgetContent
    
    struct HeaderWidgetContent : Codable {
        let title : String
    }
}


