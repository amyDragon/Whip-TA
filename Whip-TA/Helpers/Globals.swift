//
//  Globals.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import Foundation

class Globals {
    
    static func getData<T: Decodable>(url: String, for type: T.Type, _ completion: ((T?) -> ())? = nil){
        guard let dataUrl = URL(string: url) else {
            print("incorrect url \(url)")
            //TODO:: replace with alert
            return;
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: dataUrl) { data, response, error in
            
            guard error == nil, let data = data else {
                //TODO::remove prints
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
