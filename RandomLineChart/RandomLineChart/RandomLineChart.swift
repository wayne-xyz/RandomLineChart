//
//  RandomLineChart.swift
//  ChartTest
//
//  Created by zoe on 14/12/25.
//  Copyright (c) 2014年 LivinSpring. All rights reserved.
// 1.0cRandomLineChart
// 1.0:   only 3 xlabel, 3 ylable,only first quadrant,y should be cgfloat ,x should beNSdate,first SetUI,second setData,end drawLine

import Foundation
import UIkit

class RandomLineChart:UIView {
    
    var xChartLables:[UILabel] = []  //from the small one to max one
    var yChartLables:[UILabel] = []
    
    var originalXData:NSMutableArray = NSMutableArray() //originData, like nsdate,y ,it will change to chart coordinate data x
    var originalYData:NSMutableArray = NSMutableArray() //must x.count = y.count
    var linePath:UIBezierPath = UIBezierPath()
    var chartLineLayer:CAShapeLayer = CAShapeLayer()
    
    //uiSize , you can do some custom setting
    var xLabelHeight:CGFloat = 20
    var lineWidth:CGFloat = 4
    //uicolor, you can do some custom setting
    var chartFillColor:UIColor = UIColor.whiteColor() //this is backgroudcolor of the chart
    
    var chartLineColor:UIColor = UIColor.blackColor()
    
    
    enum ChartMode {  //this is x mode in particular,y is always from zero to max
        case NSDateMode  //x should be NSDate,and from min to max,y is double or float and from 0 to max
        case MinToMax
        case ZeroToMax
    }
    
    
    
    
    
    func drawLine(){ //draw the line to this chart
        
        chartLineLayer.frame=self.bounds
        chartLineLayer.path = linePath.CGPath
        chartLineLayer.strokeColor = chartLineColor.CGColor
        chartLineLayer.lineWidth = lineWidth
        chartLineLayer.fillColor = chartFillColor.CGColor
        chartLineLayer.strokeStart = 0.0
        chartLineLayer.strokeEnd = 1.0
        
        CATransaction.begin()
        var pathAnimation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1.0
        chartLineLayer.addAnimation(pathAnimation, forKey: "strokeEndAnimation")
        chartLineLayer.strokeEnd = 1.0
        CATransaction.commit()
        
        self.layer.addSublayer(chartLineLayer)
        self.backgroundColor = chartFillColor
        
        showLabels()
     
    }
    
    func showLabels(){
        //x labels
        var xLableCount = CGFloat( xChartLables.count)
        for var xi:NSInteger = 0 ; xi < xChartLables.count ; ++xi{
            var label:UILabel = xChartLables[xi]
            label.sizeToFit()
            var x = CGFloat(xi) * (self.frame.width / (xLableCount - 1))
            var y = self.frame.height - xLabelHeight
            var xWidth = label.frame.width
            if xi == xChartLables.count - 1 {  //the last xlabel shoud be totally in frame of the chart 
                x = x - xWidth
            }
            label.frame = CGRect(x: x, y: y, width: xWidth, height: xLabelHeight)
            self.addSubview(label)
            
        }
        //y labels
        var yLabelCount = CGFloat(yChartLables.count)
        for var yi:NSInteger = 0 ; yi < yChartLables.count ; ++yi{
            var y = self.frame.height  - CGFloat(yi+1) * ((self.frame.height - xLabelHeight) / yLabelCount)
            var label:UILabel = yChartLables[yi]
            label.sizeToFit()
            label.frame=CGRect(x: 0, y: y, width: label.frame.width, height: label.frame.height)
            self.addSubview(label)
        }
        
        
    }
    
    
    func setData(xData:NSMutableArray,yData:NSMutableArray,cMode:ChartMode){  //change originalx,ydate to linePath
        originalXData=xData
        originalYData=yData
        var yMax = arrayMax(yData)
        
        var chartHeight = self.frame.size.height - xLabelHeight
        var chartWidth = self.frame.size.width
        xChartLables = []
        yChartLables = []
        
        if cMode == ChartMode.NSDateMode {  //change NSDate from zero to max,unit is s
            var lastDate = originalXData.lastObject as NSDate
            var firstDate = originalXData.firstObject as NSDate
            var xAllInterval = lastDate.timeIntervalSinceDate(firstDate) //the length from min to max
            for var ind:NSInteger = 0;ind < originalXData.count ;++ind {
                var yValue = originalYData.objectAtIndex(ind) as CGFloat
                var yProportion =  (yMax - yValue) / yMax
                var xValue = originalXData.objectAtIndex(ind) as NSDate
                var indInterval = xValue.timeIntervalSinceDate(firstDate)
                var xProportion = CGFloat( indInterval / xAllInterval)
                var x = xProportion * chartWidth
                var y = yProportion * chartHeight
                //println("x:\(x) , y\(y)")
                if ind == 0 {
                    linePath.moveToPoint(CGPoint(x: x, y: y))
                }else{
                    linePath.addLineToPoint(CGPoint(x: x, y: y))
                }
            }
            
            //three Label style
            var xLabelMaxText:NSString = NSString(format: "%02d:%02d", NSInteger(xAllInterval) / 3600,NSInteger(xAllInterval) % 3600 / 60)  //show hh:mm format
            var xLabelMidText:NSString = NSString(format: "%02d:%02d", NSInteger(xAllInterval)  / 2 / 3600,NSInteger(xAllInterval) / 2 % 3600 / 60)  //show hh:mm format
            var xLabelMinText:NSString = "0"
            var xLabelStr:[NSString] = [xLabelMinText,xLabelMidText,xLabelMaxText]
            for xlstr in xLabelStr {
                var xLabel:UILabel = UILabel()
                xLabel.text = xlstr
                xChartLables.append(xLabel)
            }
            
            
            var yLabelMaxText:NSString = "\(yMax)"  //ylabel only 2 labels
            var yLabelMidText:NSString = "\(yMax/2)"
            var yLabels:[NSString] = [yLabelMidText,yLabelMaxText]
            for ylstr in yLabels{
                var yLabel:UILabel = UILabel()
                yLabel.text = ylstr
                yChartLables.append(yLabel)
            }
        }
        
        
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
    
    func removeAllLayers(){
        if self.isKindOfClass(UIView) {
            self.layer.sublayers.removeAll(keepCapacity: true)
            chartLineLayer.removeFromSuperlayer()
            self.layer.sublayers=nil
        }
        
    }
    
}