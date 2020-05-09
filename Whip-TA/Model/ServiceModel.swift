//
//  ServiceModel.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class ServiceModel {
    
    public struct Items : Decodable {
        var avg         : String?
        var description : String
        var growth      : Int
        var title       : String
        var total       : Int?
    }
    
    public struct Service : Decodable {
        var description : String
        var items       : [Items]
        var title       : String
    }
}
