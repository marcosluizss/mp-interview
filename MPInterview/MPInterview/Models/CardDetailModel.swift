//
//  CardDetailModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

struct CardDetailModel : Codable {
    var cardNumber : String
    var cardName : String
    var expirationDate : String
    var availableLimit : String
    var totalLimit : String
}
