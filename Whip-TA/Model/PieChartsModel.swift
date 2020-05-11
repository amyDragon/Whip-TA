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
        var key   : Key
        var value : Double
        
        enum Key: String, Decodable {
            case Battery = "BATTERY"
            case Jobs = "jobs"
            case Labour = "Labour"
            case MobileService = "MOBILE_SERVICE"
            case PostWarrantyService = "POST_WARRANTY_SERVICE"
            case Product = "Product"
            case Services = "services"
            case Tyre = "TYRE"
            case WarrantyService = "WARRANTY_SERVICE"
        }
    }
    
    public struct PieChart : Decodable {
        var chartType   : String
        var description : String
        var items       : [Items]
        var title       : String
    }
}
