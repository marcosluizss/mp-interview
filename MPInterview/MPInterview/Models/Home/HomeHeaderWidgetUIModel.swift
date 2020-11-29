//
//  HomeHeaderWidgetUIModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 27/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

public struct HomeHeaderWidgetUIModel : HomeHeaderModelProtocol {
    public var title : String
}

extension HomeHeaderWidgetUIModel {
    static func fromHomeWidget(homeWidget: HomeWidget) -> HomeHeaderWidgetUIModel {
        
        let title = homeWidget.content.title
            
        return HomeHeaderWidgetUIModel(title: title)
    }
}
