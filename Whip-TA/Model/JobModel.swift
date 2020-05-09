//
//  Job.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class JobModel {
    
    public struct Items : Decodable {
        var avg         : String?
        var description : String
        var growth      : Int
        var title       : String
        var total       : Int?
    }
    
    public struct Job : Decodable {
        var description : String
        var items       : [Items]
        var title       : String
    }
}
