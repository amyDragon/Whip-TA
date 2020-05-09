//
//  ViewController.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAnalytics()
    }
    
    func getAnalytics() {
        //TODO::scope check. Should never be empty
        AnalyticsModel.getAnalytics(scope:"ALL") { (result) in
            guard let result = result else {
                //TODO::Set alert
                print("error getting result")
                return
            }
            print("result \(result)")
        }
    }


}

