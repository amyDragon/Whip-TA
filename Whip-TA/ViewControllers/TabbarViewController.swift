//
//  TabbarViewController.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    let layerGradient = CAGradientLayer()
    let startColor = #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1)
    let endColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGUI()
    }
    
    func setupGUI(){
        layerGradient.colors = [startColor.cgColor, endColor.cgColor]
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tabBar.layer.insertSublayer(layerGradient, at:0)
    }
}
