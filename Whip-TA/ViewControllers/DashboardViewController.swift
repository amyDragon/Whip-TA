//
//  ViewController.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 09/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import UIKit
import Charts

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var ratingTitle: UILabel!
    @IBOutlet weak var scopeLabel: UILabel!
    @IBOutlet weak var ratingDescription: UILabel!
    @IBOutlet weak var chartCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    fileprivate var rating              = 0
    fileprivate var selectedScope       = ""
    fileprivate var showLineChart       = false //intented to choose between displaying the lineChart and piechart
    
    //scopeOptions enum in order to display options to the user in a more appropriate format
    enum scopeOptions: String {
        case ALL = "All", TODAY = "Today", LAST_7_DAYS = "Last 7 days", LAST_30_DAYS = "Last 30 days"
        static let scopeList = [ALL, TODAY, LAST_7_DAYS, LAST_30_DAYS]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartCollectionView.delegate = self
        chartCollectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAnalytics()
    }
    
    func getAnalytics() {
        Globals.getAnalytics(scope: Globals.scope) { (success) in
            guard success else {
                let alert = UIAlertController(title: "Sorry", message: "Something went wrong. Please try again later.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.async {
                self.setupGUI()
                self.chartCollectionView.reloadData()
            }
        }
    }
    
    func setupGUI() {
        scopeLabel.text = Globals.scope
        pageControl.numberOfPages = Globals.piechartData.count
        
        if let ratings = Globals.ratingsData {
            ratingTitle.text       = ratings.title
            ratingDescription.text = ratings.description
            
            //Visually displaying the rating
            for subview in ratingStackView.subviews { subview.removeFromSuperview() }
            for i in 1...5 {
                ratingStackView.addArrangedSubview(getRating(index: i, average: ratings.avg))
            }
        }
    }
    
    func getRating(index: Int, average: Int) -> UIView {
        let starImage    = UIImageView()
        var imageName    = ""
        
        imageName = index > average ? "star" : "filledStar"
        starImage.image = UIImage(named: imageName)
        starImage.contentMode = .scaleAspectFit
        return starImage
    }
    
    // MARK : IBActions
    @IBAction func onScopeButtonPress(_ sender: UIButton) {
        pickerView.delegate = self
        pickerView.dataSource = self
        showPicker()
    }
    
    @IBAction func onDonePress(_ sender: UIBarButtonItem) {
        dismissPickerView()
    }
    
    // MARK : chart functions in a separate extension swift file
    //Segment control intented to switch between Linechart and Piechart
    //Not used due to some errors
    @IBAction func onPressSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showLineChart = false
            pageControl.numberOfPages = Globals.piechartData.count
        case 1:
            showLineChart = true
            pageControl.numberOfPages = Globals.linechartData.count
        default:
            break
        }
        chartCollectionView.reloadData()
    }
}

extension DashboardViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func showPicker() {
        view.bringSubviewToFront(pickerContainerView)
        pickerContainerView.isHidden = false
    }
    
    func dismissPickerView() {
        pickerContainerView.isHidden = true
        Globals.scope = selectedScope
        getAnalytics() //refresh page data based on scope selected
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scopeOptions.scopeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = scopeOptions.scopeList[row].rawValue
        let title = NSAttributedString(string: titleData, attributes: [.foregroundColor:#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedScope = String(describing: scopeOptions.scopeList[row])
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(chartCollectionView.contentOffset.x / chartCollectionView.frame.width)
        pageControl.currentPage = index
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = showLineChart ? Globals.linechartData.count : Globals.piechartData.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as! PieChartCollectionViewCell
        
        cell.chartTitle.text = Globals.piechartData[indexPath.row].title
        cell.chartDescription.text = Globals.piechartData[indexPath.row].description
        
        cell.piechartView.isHidden  = showLineChart ? true : false
        cell.lineChartView.isHidden = showLineChart ? false : true
        if showLineChart {
            cell.lineChartView.data = setLineChartData(index: indexPath.row)
        }
        else {
            cell.piechartView.data = setPieChartData(index: indexPath.row)
            cell.piechartView.holeColor = .clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chartCollectionView.bounds.width, height: chartCollectionView.bounds.height)
    }
}
