//
//  JobsServicesViewController.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 11/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import UIKit

class JobsServicesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    fileprivate var tableData = [AnalyticsModel.Items]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let jobsData = Globals.jobsData {
            tableData = jobsData.items
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        setupGUI()
    }
    
    func setupGUI() {
        tableView.separatorStyle = .none
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
    }
    
    @IBAction func onSegmentControlPress(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if let jobData = Globals.jobsData {
                tableData = jobData.items
            }
        case 1:
            if let serviceData = Globals.serviceData {
                tableData = serviceData.items
            }
        default:
            break
        }
        tableView.reloadData()
    }
    
}

extension JobsServicesViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        cell.itemTitle.text = tableData[indexPath.row].title
        cell.itemDescription.text = tableData[indexPath.row].description
        let imageName = tableData[indexPath.row].growth > 0 ? "arrow.up" : "arrow.down"
        cell.growthImage.image = UIImage(systemName: imageName)
        cell.growthNumber.text = String(tableData[indexPath.row].growth)
        return cell
    }
}
