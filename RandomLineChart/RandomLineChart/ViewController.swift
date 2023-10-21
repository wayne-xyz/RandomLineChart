//
//  ViewController.swift
//  RandomLineChart
//
//  Created by zoe on 14/12/29.
//  Copyright (c) 2014年 LivinSpring. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var chartView: RandomLineChart! //this is the chart View in stroyboard,and have been setted a custom class "RandomLineChart"
    var makeChartEm:Bool=false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        if makeChartEm == true {
            chartView.removeAllLayers()
        }
        TestData()
        makeChartEm=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func TestData(){
        //here is test data
   
        let ytest:NSMutableArray = [0.0,10.2,13.44,16,12]
        let xtest:NSMutableArray = NSMutableArray()
        let dateFormatter:DateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date:NSDate = dateFormatter.date(from: "2010-08-04 16:01:03")! as NSDate
        let date2:NSDate = dateFormatter.date(from: "2010-08-04 16:03:03")! as NSDate
        let date3:NSDate = dateFormatter.date(from: "2010-08-04 16:07:43")! as NSDate
        let date4:NSDate = dateFormatter.date(from: "2010-08-04 16:12:13")! as NSDate
        let date5:NSDate = dateFormatter.date(from:"2010-08-04 16:14:23")! as NSDate
        xtest.add(date)
        xtest.add(date2)
        xtest.add(date3)
        xtest.add(date4)
        xtest.add(date5)
        
        chartView.setData(xData: xtest, yData: ytest, cMode: RandomLineChart.ChartMode.NSDateMode)
        chartView.drawLine()
   
    }
    
}

