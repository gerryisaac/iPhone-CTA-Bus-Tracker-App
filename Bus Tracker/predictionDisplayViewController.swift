//
//  predictionDisplayViewController.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 11/3/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit
import Foundation

class predictionDisplayViewController: UIViewController, UIScrollViewDelegate {
    
    var routeNumber:NSString? = NSString()
    var stopNumber:NSString? = NSString()
    var tagValue:Int?
    
    //Variable to Hold Scroll Data
    var stops: NSArray = []
    var stopData: NSMutableArray =  []
    var stopCount: Int = 0
    
    //Scroll View
    var mainScroll:UIScrollView = UIScrollView()
    var pageControl:UIPageControl = UIPageControl()
    
    var rxml:RXMLElement = RXMLElement()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blackColor()
        
        //Run Data Function
        populatePredictions(routeNumber!,stopNum: stopNumber!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Retrieve Data for Selected Stop in this Route
    func populatePredictions(routeNum: NSString, stopNum: NSString) {
        
        //Create Spinner
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.frame = CGRectMake(self.view.frame.size.width/2 - 25, self.view.frame.size.height/2, 50, 50);
        spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //spinner.backgroundColor = [UIColor blackColor];
        
        self.view.addSubview(spinner);
        spinner.startAnimating()
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/getpredictions?key=\(yourCTAkey.keyValue)&rt=\(routeNum)&stpid=\(stopNum)"
        //println("Feed URL is \(feedURL)")
        
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        let contentType:NSSet = NSSet(object: "text/xml")
        manager.responseSerializer.acceptableContentTypes = contentType
        
        manager.GET(feedURL,
            parameters: nil,
            success: {
                (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                //println("Success")
                
                var responseData:NSData = responseObject as NSData
                //var responseString = NSString(data: responseData, encoding:NSASCIIStringEncoding)
                //println(responseString)
                
                self.rxml = RXMLElement.elementFromXMLData(responseData) as RXMLElement
                //println(rxml)
                
                var mainXML:RXMLElement = self.rxml.child("*")
                
                var checker:NSString = mainXML.tag
                //println(checker)
                
                /*Pattern Checker*/
                if checker.isEqualToString("prd") {

                    //println("Build Scrollview")
                    //println("EQUAL Response:\(responseString)")
                    
                    self.stops = self.rxml.children("prd")
                    self.stopData.addObjectsFromArray(self.stops)
                    self.stopCount = self.stopData.count
                    //println(self.stops)
                    //println(self.stopCount)
                    
                    self.createScrollDataScreen(self.stopCount)
                    
                    
                } else {
                    
                    let searchString:NSString = "//msg"
                    self.rxml.iterateWithRootXPath(searchString, usingBlock: { appElement -> Void in
                        //println(appElement.text)
                        //println("ELSE Response:\(responseString)")
                        
                        //Create Background Image
                        let bgImage = UIImage(named:"patternsCellNoticeBgI5.png")!
                        var bgImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, screenDimensions.screenHeight))
                        bgImageView.image = bgImage
                        self.view.addSubview(bgImageView)
                        
                        var txtField: UILabel = UILabel(frame:CGRectMake(screenDimensions.screenWidth/2 - 100, screenDimensions.screenHeight/2 - 110, 220, 100))
                        txtField.backgroundColor = UIColor.clearColor()
                        txtField.font = UIFont(name:"Gotham-Light", size:40.0)
                        txtField.textAlignment = NSTextAlignment.Center
                        txtField.numberOfLines = 0
                        txtField.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        txtField.textColor = UIColor.whiteColor()
                        var message:NSString = appElement.text
                        txtField.text = message.capitalizedString
                        self.view.addSubview(txtField)
                    })

                }
                
                spinner.stopAnimating()
                
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                var alertView = UIAlertView(title: "Error Retrieving Data", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                println(error)
        })
    
    }
    
    func createScrollDataScreen(pageCount:Int){
        
        //Create Scrollview
        var currentWidth:CGFloat = 0.0
        let fixedHeight:CGFloat = 504
        
        var scrollViewFrame:CGRect = CGRectMake(0, 64, screenDimensions.screenWidth, fixedHeight)
        
        var bgImage:UIImage = UIImage(named:"predictionsScrollBg.png")!
        var bgPlaceholder:UIImageView = UIImageView(frame: scrollViewFrame)
        bgPlaceholder.image = bgImage
        self.view.addSubview(bgPlaceholder)
        
        self.mainScroll = UIScrollView(frame: scrollViewFrame)
        self.mainScroll.backgroundColor = UIColor.clearColor()
        
        //Set delegate
        self.mainScroll.delegate = self
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = true
        
        var scrollContent:UIView = UIView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, fixedHeight))
        scrollContent.frame = CGRectMake(0, 0, screenDimensions.screenWidth * CGFloat(pageCount), fixedHeight)
        
        //Time Stamp
        var timeStamp:NSString = "0"
        //Type
        var stopType :NSString?
        //Stop Name
        var stopName :NSString?
        //Stop ID Number
        var stopID :NSString?
        //Vehicle ID Number
        var vehicleID :NSString?
        //Distance to Stop
        var distanceStop :NSString?
        //Route Number
        var routeNum :NSString?
        //Route Direction
        var routeDir :NSString?
        //Destination
        var destination :NSString?
        //Predicted Time
        var predictedTime :NSString = "0"
        //Block ID
        var blockID :NSString?
        //Trip ID
        var tripID :NSString?
        
        var rootXML:RXMLElement = self.rxml.child("prd")
        rootXML.iterateElements(self.stops, usingBlock: { appElement -> Void in
            
            //Time Stamp
            timeStamp = appElement.child("tmstmp").text
            //Type
            stopType = appElement.child("typ").text
            //Stop Name
            stopName = appElement.child("stpnm").text
            //Stop ID Number
            stopID = appElement.child("stpid").text
            //Vehicle ID Number
            vehicleID = appElement.child("vid").text
            //Distance to Stop
            distanceStop = appElement.child("dstp").text
            //Route Number
            routeNum = appElement.child("rt").text
            //Route Direction
            var routeDir = appElement.child("rtdir").text
            //self.switchRouteDir(routeDir!)
            switch routeDir {
            case "Northbound":
                routeDir = "NB"
            case "Southbound":
                routeDir = "SB"
            case "Westbound":
                routeDir = "WB"
            case "Eastbound":
                routeDir = "EB"
            default:
                routeDir = appElement.child("rtdir").text
            }
            
            //Destination
            destination = appElement.child("des").text
            //Predicted Time
            predictedTime = appElement.child("prdtm").text
            //Block ID
            blockID = appElement.child("tablockid").text
            //Trip ID
            tripID = appElement.child("tatripid").text
            
            //Format the Date
            var dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(name:"GMT")
            dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
            dateFormatter.dateFormat = "yyyyMMdd HH:mm"
            
            var currentDate:NSDate = dateFormatter.dateFromString(timeStamp)!
            var predictedDate:NSDate = dateFormatter.dateFromString(predictedTime)!
            //println("Current Date: \(currentDate) and Predicted Time: \(predictedDate)")
            
            //let calendar = NSCalendar.currentCalendar()
            //let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: currentDate)
            //let hour = components.hour
            //let minutes = components.minute
            //println("Current Date Minutes: \(minutes)")
            
            //date2 = dateFormatter.dateFromString(predictedTime!)
            //dateFormatter.dateFormat = "mm"
            
            //Time difference in seconds
            var timeDifference:NSTimeInterval = NSTimeInterval()
            timeDifference = predictedDate.timeIntervalSinceDate(currentDate)
            //println("Time Difference: \(timeDifference)")
            
            //println("Timestamp:\(timeStamp) Type:\(type) Stop Name:\(stopName) Stop ID:\(stopID) Vehicle ID:\(vehicleID) Distance to Stop:\(distanceStop) Route Number: \(routeNum) Route Direction:\(routeDir) Destination:\(destination) Predicted Time:\(predictedTime) Block ID:\(blockID) Trip ID:\(tripID) Estimated Arrival: \(timeDifference/60) minutes")
            
            //Create ScrollView Content and add Pages for Holding the Data
            var xLocation:CGFloat = 0.0
            
            //var pageEntry: UIView = UIView(frame:CGRectMake(xLocation + currentWidth, 0, 320, 416))
            var pageEntry: predictionPageEntry = predictionPageEntry(frame:CGRectMake(xLocation + currentWidth, 0, screenDimensions.screenWidth, fixedHeight))
            
            pageEntry.timeStampLabel.text = timeStamp
            pageEntry.stopTypeLabel.text = stopType
            pageEntry.stopNameLabel.text = stopName
            pageEntry.vehicleIDLabel.text = vehicleID
            pageEntry.distanceStopLabel.text = distanceStop
            pageEntry.routeNumLabel.text = routeNum
            pageEntry.routeDirLabel.text = routeDir
            pageEntry.destinationLabel.text = destination
            pageEntry.predictedTimeLabel.text = "\(timeDifference/60) minutes"
            pageEntry.blockIDLabel.text = blockID
            pageEntry.tripIDLabel.text = tripID
            
            //Add Time Button Tag
            //Extract Integer Value of Stop ID and Assign as Tags to Buttons
            self.tagValue = NSString(string: vehicleID!).integerValue
            //println(self.tagValue)
            
            pageEntry.busLocation.tag = self.tagValue!
            pageEntry.busLocation.addTarget(self, action: "locationButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            currentWidth = currentWidth + pageEntry.frame.size.width
            scrollContent.addSubview(pageEntry)
            
            //println("Page Made")
        
        })
        
        var scrollViewContentSize:CGSize = CGSizeMake(screenDimensions.screenWidth * CGFloat(pageCount), fixedHeight);
        self.mainScroll.contentSize = scrollViewContentSize
        self.mainScroll.addSubview(scrollContent)
        self.view.addSubview(self.mainScroll)
        
        if pageCount > 1 {
            
            //Create Page Control View
            var pageControlBg:UIView = UIView(frame: CGRectMake(0, screenDimensions.screenHeight - 30, screenDimensions.screenWidth, 30))
            pageControlBg.backgroundColor = UIColor.blackColor()
            pageControlBg.alpha = 0.5
            self.view.addSubview(pageControlBg)
            
            //x y width height
            pageControl.frame = CGRectMake(100, screenDimensions.screenHeight - 30, screenDimensions.screenWidth - 200, 30)
            pageControl.numberOfPages = pageCount
            pageControl.currentPage = 0
            pageControl.userInteractionEnabled = false
            
            self.view.addSubview(pageControl)
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("Scrolled")
        var pageWidth:CGFloat = self.mainScroll.frame.size.width;
        var page:Int = Int(floor((self.mainScroll.contentOffset.x - pageWidth / 2 ) / pageWidth)) + 1; //this provides the page number
        self.pageControl.currentPage = page;// this displays the white dot as current page
    }
    
    //Bus Location Button Action
    func locationButtonAction(sender:UIButton!) {
        
        //println("Bus Location Tapped")
        
        //Cast Self and Get Tag Number
        let button:UIButton = sender
        //println(button.tag)
        
        //Display Bus Location Using Vehicle ID
        var busLocMap:mapModalViewController = mapModalViewController()
        busLocMap.busID = String(button.tag)
        
        busLocMap.view.frame = CGRectMake(0, 20, screenDimensions.screenWidth, screenDimensions.screenHeight)
        busLocMap.view.backgroundColor = UIColor.blackColor()
        self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.presentViewController(busLocMap, animated: true, completion: nil)
        
    }


}
