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
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    func TestData(){
        //here is test data
   
        var ytest:NSMutableArray = [0.0,10.2,13.44,16,12]
        var xtest:NSMutableArray = NSMutableArray()
        var dateFormatter:NSDateFormatter =  NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var date:NSDate = dateFormatter.dateFromString("2010-08-04 16:01:03")!
        var date2:NSDate = dateFormatter.dateFromString("2010-08-04 16:03:03")!
        var date3:NSDate = dateFormatter.dateFromString("2010-08-04 16:07:43")!
        var date4:NSDate = dateFormatter.dateFromString("2010-08-04 16:12:13")!
        var date5:NSDate = dateFormatter.dateFromString("2010-08-04 16:14:23")!
        xtest.addObject(date)
        xtest.addObject(date2)
        xtest.addObject(date3)
        xtest.addObject(date4)
        xtest.addObject(date5)
        
        chartView.setData(xtest, yData: ytest, cMode: RandomLineChart.ChartMode.NSDateMode)
        chartView.drawLine()
   
    }
    
}

