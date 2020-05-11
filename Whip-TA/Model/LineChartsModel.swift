//
//  LineChartsModel.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 11/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class LineChartsModel {
    
    public struct Value : Decodable {
        var key   : String
        var value : Double
    }
    
    public struct Items : Decodable {
        var key   : String
        var value : [Value]
    }
    
    public struct LineChart : Decodable {
        var chartType   : String
        var description : String
        var items       : [Items]
        var title       : String
    }
}
