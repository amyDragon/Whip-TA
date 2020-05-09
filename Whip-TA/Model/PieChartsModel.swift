//
//  PieChartsModel.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class PieChartsModel {
    
    public struct Items : Decodable {
        var key   : String
        var value : Double
    }
    
    public struct PieChart : Decodable {
        var chartType   : String
        var description : String
        var items       : [Items]
        var title       : String
    }
}
