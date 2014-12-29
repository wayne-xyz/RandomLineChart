//
//  RandomLineChart.swift
//  ChartTest
//
//  Created by zoe on 14/12/25.
//  Copyright (c) 2014年 LivinSpring. All rights reserved.
// 1.0cRandomLineChart
// 1.0:   only 3 xlabel, 3 ylable,only first quadrant,y should be cgfloat ,x should be

import Foundation
import UIkit

class RandomLineChart:UIView {
    
    var xChartLables:[UILabel] = []
    var yChartLables:[UILabel] = []
    
    var originalXData:NSMutableArray = NSMutableArray() //originData, like nsdate,y ,it will change to chart coordinate data x
    var originalYData:NSMutableArray = NSMutableArray() //must x.count = y.count
    var linePath:UIBezierPath = UIBezierPath()
    
    
    
    //ui
    var xLabelHeight:CGFloat = 10.0
    
    
    enum ChartMode {  //this is x mode in particular,y is always from zero to max
        case NSDateMode  //x should be NSDate,and from min to max just like 2014/12/22 12:30 - 2015/3/10 12.10,y is double or float
        case MinToMax
        case ZeroToMax
    }
    
    
    
    
    func drawLine(){ //draw the line to this chart
        var chartLineLayer:CAShapeLayer = CAShapeLayer()
        chartLineLayer.frame=self.bounds
        chartLineLayer.strokeColor = UIColor.blueColor().CGColor
        chartLineLayer.path = linePath.CGPath
        chartLineLayer.lineWidth = 4
        
        chartLineLayer.fillColor = UIColor.whiteColor().CGColor
        chartLineLayer.strokeStart = 0.0
        chartLineLayer.strokeEnd = 1.0
        self.layer.addSublayer(chartLineLayer)
        self.backgroundColor = UIColor.whiteColor()
        println(chartLineLayer.path)
    }
    
    
    
    func setData(xData:NSMutableArray,yData:NSMutableArray,cMode:ChartMode){  //change originalx,ydate to linePath
        originalXData=xData
        originalYData=yData
        var yMax = arrayMax(yData)
        
        var chartHeight = self.frame.size.height - xLabelHeight
        var chartWidth = self.frame.size.width
        
        if cMode == ChartMode.NSDateMode {  //change NSDate from zero to max,unit is s
            var lastDate = originalXData.lastObject as NSDate
            var firstDate = originalXData.firstObject as NSDate
            var xAllInterval = lastDate.timeIntervalSinceDate(firstDate)
            for var ind:NSInteger = 0;ind < originalXData.count ;++ind {
                var yValue = originalYData.objectAtIndex(ind) as CGFloat
                var yProportion =  (yMax - yValue) / yMax
                
                var xValue = originalXData.objectAtIndex(ind) as NSDate
                var indInterval = xValue.timeIntervalSinceDate(firstDate)
                var xProportion = CGFloat( indInterval / xAllInterval)
                
                var x = xProportion * chartWidth
                var y = yProportion * chartHeight
                println("x:\(x) , y\(y)")
                if ind == 0 {
                    linePath.moveToPoint(CGPoint(x: x, y: y))
                }else{
                    linePath.addLineToPoint(CGPoint(x: x, y: y))
                }
            }
        }
        
        println("setdata is down")
    }
    
    
    func arrayMax(ar:NSMutableArray)-> CGFloat{ //get max value of arrayValue,after setData,ydata is always >0
        var max:CGFloat = 0.0
        for one in ar {
            var o:CGFloat = one as CGFloat
            if o > max {
                max=o
            }
        }
        return max
    }
    
    
}