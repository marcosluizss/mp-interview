//
//  StatementDetailModel.swift
//  MPInterview
//
//  Created by Marcos Luiz on 28/11/20.
//  Copyright © 2020 ml2s. All rights reserved.
//

import Foundation

struct StatementModel : Codable {
    var balance : StatementDetailBalance
    var transactions : [StatementDetailTransactions]
}

struct StatementDetailBalance : Codable {
    var label : String
    var value : String
}

struct StatementDetailTransactions : Codable {
    var label : String
    var value : String
    var description : String
}

