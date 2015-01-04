RandomLineChart
===============

A sample line chart for iOS by swift, it support asymmetric NSDate as X axis data.
All code is in swift,And Myview in Demo is set in storyboard.
My Demo Code:

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
![alt](http://www.zoejblog.com/content/images/2015/01/-----2015-01-04---10-40-21.png)

It is a simple chart and it has some bug.
