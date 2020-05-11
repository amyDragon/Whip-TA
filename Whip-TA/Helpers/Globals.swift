//
//  Globals.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import UIKit

class Globals {
    
    public static var jobsData    : JobModel.Job?
    public static var ratingsData : RatingsModel.Rating?
    public static var serviceData : ServiceModel.Service?
    
    public static var piechartData  = [PieChartsModel.PieChart]()
    public static var linechartData = [[LineChartsModel.LineChart]]()
    public static var scope         = "ALL"
    
    //getAnalytics set as a global function in order to be accessible from any class if needed
    //Added a completion handler returing success boolean to allow the class to decide what to do
    static func getAnalytics(scope: String, completion: @escaping (Bool)->()) {
        var success = false
        AnalyticsModel.getAnalytics(scope:scope) { (result) in
            guard let result = result else {
                print("error getting result")
                completion(success)
                return
            }
            DispatchQueue.main.async {
                if let data = result.response.data {
                    self.jobsData       = data.analytics.job
                    self.piechartData   = data.analytics.pieCharts
                    self.ratingsData    = data.analytics.rating
                    self.serviceData    = data.analytics.service
                    
                    if let lineChartData = data.analytics.lineCharts {
                        self.linechartData  = lineChartData
                    }
                }
            }
            success = true
            completion(success)
        }
    }
    
    //Get request with a type parameter allowing the developer to specify the type/format of data expected
    static func getData<T: Decodable>(url: String, for type: T.Type, _ completion: ((T?) -> ())? = nil){
        guard let dataUrl = URL(string: url) else {
            print("incorrect url \(url)")
            return;
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: dataUrl) { data, response, error in
            
            guard error == nil, let data = data else {
                print("error \(String(describing: error)), data issue")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json: T? = try JSONDecoder().decode(T.self, from: data)
                completion?(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
                completion?(nil)
                return
            }
        }
        
        task.resume()
    }
}
