//
//  Globals.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class Globals {
    
    public static var jobsData    : JobModel.Job?
    public static var ratingsData : RatingsModel.Rating?
    public static var serviceData : ServiceModel.Service?
    
    public static var piechartData = [PieChartsModel.PieChart]()
    public static var scope        = "ALL"
    
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
                }
            }
            success = true
            completion(success)
        }
    }
    
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
