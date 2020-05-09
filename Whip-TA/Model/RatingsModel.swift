//
//  RatingsModel.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class RatingsModel {
    
    public struct Rating : Decodable {
        var avg         : Int
        var description : String
        var items       : [String : Int]
        var title       : String
    }
}
