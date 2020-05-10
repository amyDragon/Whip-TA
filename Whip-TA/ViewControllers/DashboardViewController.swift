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
    
    fileprivate let colors              = [ #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) ]
    fileprivate var rating              = 0
    fileprivate var selectedScope       = ""
    fileprivate var scopeList           = ["ALL", "TODAY", "LAST_7_DAYS", "LAST_30_DAYS"]
    
    fileprivate var chartData  : PieChartData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartCollectionView.delegate = self
        chartCollectionView.dataSource = self
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
        if let ratings = Globals.ratingsData {
            ratingTitle.text       = ratings.title
            ratingDescription.text = ratings.description
            
            for subview in ratingStackView.subviews { subview.removeFromSuperview() }
            for i in 1...5 {
                ratingStackView.addArrangedSubview(getRating(index: i, average: ratings.avg))
            }
        }
        pageControl.numberOfPages = Globals.piechartData.count
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
    
    // MARK : chart functions
    private func setPieChartData(index: Int) -> PieChartData{
        var keys   = [String]()
        var values = [Double]()
        let chartArray : [PieChartsModel.Items] = Globals.piechartData[index].items
        
        for item in chartArray {
            keys.append(item.key)
            values.append(item.value)
        }
        let data = self.customizeChart(dataPoints: keys, values: values.map{ Double($0) })
        return data
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) -> PieChartData {
        //Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        //Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.entryLabelColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pieChartDataSet.colors = colors
        
        //Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        return pieChartData
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
        getAnalytics()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scopeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = scopeList[row]
        let title = NSAttributedString(string: titleData, attributes: [.foregroundColor:#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedScope = scopeList[row]
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(chartCollectionView.contentOffset.x / chartCollectionView.frame.width)
        pageControl.currentPage = index
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Globals.piechartData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartCell", for: indexPath) as! PieChartCollectionViewCell
        
        cell.chartTitle.text = Globals.piechartData[indexPath.row].title
        cell.chartDescription.text = Globals.piechartData[indexPath.row].description
        
        chartData = setPieChartData(index: indexPath.row)
        if let data = chartData {
            cell.piechartView.data = data
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chartCollectionView.bounds.width, height: chartCollectionView.bounds.height)
    }
}
