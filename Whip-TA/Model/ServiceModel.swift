//
//  ServiceModel.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class ServiceModel {
    
    public struct Service : Decodable {
        var description : String
        var items       : [AnalyticsModel.Items]
        var title       : String
    }
}
