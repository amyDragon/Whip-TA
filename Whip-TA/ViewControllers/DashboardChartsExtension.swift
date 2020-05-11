//
//  DashboardChartsExtension.swift
//  Whip-TA
//
//  Created by amatullah ashfaq on 12/05/2020.
//  Copyright © 2020 amy. All rights reserved.
//

import UIKit
import Charts

//DashboardViewController extension file containing all the chart based functionality
extension DashboardViewController {
    
    func setPieChartData(index: Int) -> PieChartData {
        var dataPoints   = [String]()
        var values = [Double]()
        let chartArray : [PieChartsModel.Items] = Globals.piechartData[index].items
        
        for item in chartArray {
            dataPoints.append(String(describing: item.key))
            values.append(item.value)
        }
        let data = self.customizeChart(dataPoints: dataPoints, values: values.map{ Double($0) })
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
        pieChartDataSet.entryLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let colors = [ #colorLiteral(red: 0.2392156863, green: 0.6745098039, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) ]
        pieChartDataSet.colors = colors
        
        //Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        return pieChartData
    }
    
    func setLineChartData(index: Int) -> LineChartData {
        let chartArray = Globals.linechartData[0][index].items
        var xArray = [LineChartsModel.Value]()
        var yArray = [LineChartsModel.Value]()
        
        //Example data to display:
//        "value": [
//          {
//            "key": "jobs",
//            "value": 11
//          },
//          {
//            "key": "services",
//            "value": 12
//          }
//        ]
        // xArray intended to display "jobs"
        // yArray intedned to display "services"
        
        for item in chartArray {
            for i in 0..<item.value.count {
                if i == 0 {
                    xArray.append(item.value[i])
                }
                else {
                     yArray.append(item.value[i])
                }
            }
        }
        let data = self.customizeLineChart(x: xArray, y: yArray)
        return data
    }
    
    func customizeLineChart(x:[LineChartsModel.Value], y:[LineChartsModel.Value]) -> LineChartData {
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<x.count {
            let dataEntry = ChartDataEntry(x: x[i].value, y: y[i].value)
          dataEntries.append(dataEntry)
        }
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        return lineChartData
    }
}
