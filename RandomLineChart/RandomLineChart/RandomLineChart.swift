//
//  RandomLineChart.swift
//  ChartTest
//
//  Created by zoe on 14/12/25.
//  Copyright (c) 2014年 LivinSpring. All rights reserved.
// 1.0cRandomLineChart
// 1.0:   only 3 xlabel, 3 ylable,only first quadrant,y should be cgfloat ,x should beNSdate,first SetUI,second setData,end drawLine
//upddate 2023 oct, fpr mew version swift

import Foundation
import UIKit

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
    var chartFillColor:UIColor = UIColor.white //this is backgroudcolor of the chart
    
    var chartLineColor:UIColor = UIColor.black
    
    
    enum ChartMode {  //this is x mode in particular,y is always from zero to max
        case NSDateMode  //x should be NSDate,and from min to max,y is double or float and from 0 to max
        case MinToMax
        case ZeroToMax
    }
    
    
    
    
    
    func drawLine(){ //draw the line to this chart
        
        chartLineLayer.frame=self.bounds
        chartLineLayer.path = linePath.cgPath
        chartLineLayer.strokeColor = chartLineColor.cgColor
        chartLineLayer.lineWidth = lineWidth
        chartLineLayer.fillColor = chartFillColor.cgColor
        chartLineLayer.strokeStart = 0.0
        chartLineLayer.strokeEnd = 1.0
        
        CATransaction.begin()
        let pathAnimation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1.0
        chartLineLayer.add(pathAnimation, forKey: "strokeEndAnimation")
        chartLineLayer.strokeEnd = 1.0
        CATransaction.commit()
        
        self.layer.addSublayer(chartLineLayer)
        self.backgroundColor = chartFillColor
        
        showLabels()
     
    }
    
    func showLabels(){
        //x labels
        let xLableCount = CGFloat( xChartLables.count)
        for xi in 0..<xChartLables.count{
            let label:UILabel = xChartLables[xi]
            label.sizeToFit()
            var x = CGFloat(xi) * (self.frame.width / (xLableCount - 1))
            let y = self.frame.height - xLabelHeight
            let xWidth = label.frame.width
            if xi == xChartLables.count - 1 {  //the last xlabel shoud be totally in frame of the chart 
                x = x - xWidth
            }
            label.frame = CGRect(x: x, y: y, width: xWidth, height: xLabelHeight)
            self.addSubview(label)
            
        }
        //y labels
        let yLabelCount = CGFloat(yChartLables.count)
        for yi in 0..<yChartLables.count {
            let y = self.frame.height  - CGFloat(yi+1) * ((self.frame.height - xLabelHeight) / yLabelCount)
            let label:UILabel = yChartLables[yi]
            label.sizeToFit()
            label.frame=CGRect(x: 0, y: y, width: label.frame.width, height: label.frame.height)
            self.addSubview(label)
        }
        
        
    }
    
    
    func setData(xData:NSMutableArray,yData:NSMutableArray,cMode:ChartMode){  //change originalx,ydate to linePath
        originalXData=xData
        originalYData=yData
        let yMax = arrayMax(ar: yData)
        
        let chartHeight = self.frame.size.height - xLabelHeight
        let chartWidth = self.frame.size.width
        xChartLables = []
        yChartLables = []
        
        if cMode == ChartMode.NSDateMode {  //change NSDate from zero to max,unit is s
            let lastDate = originalXData.lastObject as! NSDate
            let firstDate = originalXData.firstObject as! NSDate
            let xAllInterval = lastDate.timeIntervalSince(firstDate as Date) //the length from min to max
            for ind in 0..<originalXData.count{
                let yValue = originalYData.object(at: ind) as! CGFloat
                let yProportion =  (yMax - yValue) / yMax
                let xValue = originalXData.object(at: ind) as! NSDate
                let indInterval = xValue.timeIntervalSince(firstDate as Date)
                let xProportion = CGFloat( indInterval / xAllInterval)
                let x = xProportion * chartWidth
                let y = yProportion * chartHeight
                //println("x:\(x) , y\(y)")
                if ind == 0 {
                    linePath.move(to: CGPoint(x: x, y: y))
                }else{
                    linePath.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            //three Label style
            let xLabelMaxText:NSString = NSString(format: "%02d:%02d", NSInteger(xAllInterval) / 3600,NSInteger(xAllInterval) % 3600 / 60)  //show hh:mm format
            let xLabelMidText:NSString = NSString(format: "%02d:%02d", NSInteger(xAllInterval)  / 2 / 3600,NSInteger(xAllInterval) / 2 % 3600 / 60)  //show hh:mm format
            let xLabelMinText:NSString = "0"
            let xLabelStr:[NSString] = [xLabelMinText,xLabelMidText,xLabelMaxText]
            for xlstr in xLabelStr {
                let xLabel:UILabel = UILabel()
                xLabel.text = String(xlstr)
                xChartLables.append(xLabel)
            }
            
            
            let yLabelMaxText:NSString = "\(yMax)" as NSString //ylabel only 2 labels
            let yLabelMidText:NSString = "\(yMax/2)" as NSString
            let yLabels:[NSString] = [yLabelMidText,yLabelMaxText]
            for ylstr in yLabels{
                let yLabel:UILabel = UILabel()
                yLabel.text = String(ylstr)
                yChartLables.append(yLabel)
            }
        }
        
        
    }
    
    
    func arrayMax(ar:NSMutableArray)-> CGFloat{ //get max value of arrayValue,after setData,ydata is always >0
        var max:CGFloat = 0.0
        for one in ar {
            let o:CGFloat = one as! CGFloat
            if o > max {
                max=o
            }
        }
        return max
    }
    
    func removeAllLayers(){
        
            self.layer.sublayers?.removeAll()
            chartLineLayer.removeFromSuperlayer()
            self.layer.sublayers=nil
      
        
    }
    
}
