//
//  AnalyticsModel.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class AnalyticsModel {
    
    public struct Items : Decodable {
        var avg         : String?
        var description : String
        var growth      : Int
        var title       : String
        var total       : Int?
    }
    
    public struct Analytics : Decodable {
        var job         : JobModel.Job
        var lineCharts  : [[LineChartsModel.LineChart]]
        var pieCharts   : [PieChartsModel.PieChart]
        var rating      : RatingsModel.Rating
        var service     : ServiceModel.Service
    }
    
    public struct Data : Decodable {
        var analytics : Analytics
    }
    
    public struct Response : Decodable {
        var message : String
        var data    : Data?
    }
    
    public struct Result : Decodable {
        var httpStatus : Int
        var response   : Response
    }
    
    static func getAnalytics(scope: String, completion: @escaping (Result?)->()){
        let baseUrl = "https://skyrim.whipmobility.io/v10/analytic/dashboard/operation/mock?scope="
        let url = baseUrl + scope
        Globals.getData(url: url, for: Result.self) { (result) in
            completion(result)
        }
    }
}
