//
//  mainViewController.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/21/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let cellIdentifier = "cellIdentifier"
    //var tableData = [String]()
    let routeTable: UITableView = UITableView(frame: CGRectMake(0, 108, screenDimensions.screenWidth, screenDimensions.screenHeight - 108))
    
    var dateDisplay: UILabel = UILabel()
    var timeDisplay: UILabel = UILabel()
    
    //Route Table Data Variables
    var routes: NSArray = []
    var routeData: NSMutableArray = []
    var routeNumbersArray: NSMutableArray = []
    var routesCount: Int = 0
    var routeValue: NSString = "0"
    var routeNumber: NSString? = "0"
    
    //var cell: RouteCell = RouteCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "CTA Bus Tracker"
        self.view.backgroundColor = UIColor.blueColor()
        
        //println("Loaded")
        //Test Global Variable
        //let myHeight = screenDimensions.screenHeight
        //let myWidth = screenDimensions.screenWidth
        //println("My Height:\(myHeight) My Width:\(myWidth)")
        
        //Check Connection
        isConnectionAvailable()
        
        //Add Observer
        //var rechability:Reachability = Reachability.reachabilityForInternetConnection()
        var defaultCenter:NSNotificationCenter = NSNotificationCenter()
        defaultCenter.addObserver(self, selector: "isConnectionAvailable:", name: kReachabilityChangedNotification, object: nil)
        
        //Create Background Image
        let bgImage = UIImage(named:"bg-MainI5.png")
        var bgImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, screenDimensions.screenHeight))
        bgImageView.image = bgImage
        bgImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        //Create Header Background Image
        let headDTImage = UIImage(named:"header-DateTime.png")
        var headDTImageView = UIImageView(frame: CGRectMake(0, 64, 320, 44))
        headDTImageView.image = headDTImage
        
        //Create Date and Time Display
        var offset:Double = 64
        var dateTimeFont = UIFont(name:"Gotham-Bold", size:17.0)
        
        dateDisplay.frame = CGRectMake(54, 76, 104, 23)
        dateDisplay.textColor = UIColor.whiteColor()
        dateDisplay.textAlignment = NSTextAlignment.Left
        dateDisplay.font = dateTimeFont
        dateDisplay.text = "Loading..."
        
        timeDisplay.frame = CGRectMake(217, 76, 104, 23)
        timeDisplay.textColor = UIColor.whiteColor()
        timeDisplay.textAlignment = NSTextAlignment.Left
        timeDisplay.font = dateTimeFont
        timeDisplay.text = "Loading..."
        
        self.view.addSubview(bgImageView)
        self.view.addSubview(headDTImageView)
        
        self.view.addSubview(dateDisplay)
        self.view.addSubview(timeDisplay)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Network Connectivity
    func isConnectionAvailable()->Bool{
        
        var rechability:Reachability = Reachability.reachabilityForInternetConnection()
        var networkStatus:NetworkStatus = rechability.currentReachabilityStatus()
        
        if networkStatus == NetworkStatus.NotReachable {
            //println("Unreachable");
            var alertView = UIAlertView(
                title: "No Network Connection",
                message: "CTA Bus Tracker needs an Internet Connection to display data. Please check your Network Settings",
                delegate: nil,
                cancelButtonTitle: "OK"
            )
            alertView.show()
            return false
        
        } else {
            //println("Reachable");
            retrieveData()
            return true
        }
    }
    
    func retrieveData(){
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/gettime?key=\(yourCTAkey.keyValue)"
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
                
                var rxml:RXMLElement = RXMLElement.elementFromXMLData(responseData) as RXMLElement
                var timeElement = rxml.child("tm")
                
                //println("The Current Time is \(timeElement)")
                
                //Get the Date and Time with Format yyyymmdd hh:mm:ss
                var str:NSString = timeElement.text
                
                var dateFormatter = NSDateFormatter()
                dateFormatter.timeZone = NSTimeZone(name:"GMT")
                dateFormatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
                dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
                
                var date:NSDate = dateFormatter.dateFromString(str)!
                var currentTime:NSDate = dateFormatter.dateFromString(str)!
                
                dateFormatter.dateFormat = "MM-dd-yyyy"
                var dateString:NSString = dateFormatter.stringFromDate(date)
                
                dateFormatter.dateFormat = "HH:mm:ss"
                var timeString:NSString = dateFormatter.stringFromDate(currentTime)
                
                //println("Converted Time:\(timeString) Converted Date:\(dateString)");
                
                self.dateDisplay.text = dateString
                self.timeDisplay.text = timeString
                
                self.populateRoutes()
                
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                var alertView = UIAlertView(title: "Error Retrieving Data", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                println(error)
        })
        
    }
    
    func populateRoutes(){
        
        //Create Spinner
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.frame = CGRectMake(screenDimensions.screenWidth/2 - 25, screenDimensions.screenHeight/2 - 25, 50, 50);
        spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //spinner.backgroundColor = [UIColor blackColor];
        
        self.view.addSubview(spinner);
        spinner.startAnimating()
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/getroutes?key=\(yourCTAkey.keyValue)"
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
                
                var rxml:RXMLElement = RXMLElement.elementFromXMLData(responseData) as RXMLElement
                
                self.routes = rxml.children("route")
                self.routeData.addObjectsFromArray(self.routes)
                self.routesCount = self.routes.count
                
                //println(self.routeData)
                //println(self.routesCount)
                
                rxml.iterateElements(self.routes, usingBlock: { appElement -> Void in
                    //var routeNumber:NSString = appElement.child("rt").text
                    //var routeName:NSString = appElement.child("rtnm").text
                    //self.routeNumbersArray.addObject(routeNumber)
                    //println("Route Number: \(routeNumber) and Name: \(routeName)")
                })
                
                //Create Table
                self.routeTable.backgroundColor = UIColor.clearColor()
                self.routeTable.dataSource = self
                self.routeTable.delegate = self
                self.routeTable.separatorInset = UIEdgeInsetsZero
                self.routeTable.layoutMargins = UIEdgeInsetsZero
                
                // Register the UITableViewCell class with the tableView
                //self.routeTable.registerClass(RouteCell.self, forCellReuseIdentifier: self.cellIdentifier)
                self.routeTable.registerClass(RouteCell.self, forCellReuseIdentifier: self.cellIdentifier)
                
                //Add the Table View
                self.view.addSubview(self.routeTable)
                
                spinner.stopAnimating()
                
            },
            failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) in
                var alertView = UIAlertView(title: "Error Retrieving Data", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                println(error)
        })
        
    }
    
    //Hex Color Values Function
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    // Table Delegates and Data Source
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //println("numberOfSectionsInTableView")
        return 1
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditing indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println("numberOfRowsInSection: TableData Count = \(tableData.count)")
        return self.routesCount//tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as RouteCell
        //var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        
        var appElement = self.routeData.objectAtIndex(indexPath.row) as RXMLElement
        var routeName:NSString = appElement.child("rtnm").text
        var routeNumberRT:NSString = appElement.child("rt").text
        
        cell.indentationLevel = 0
        cell.autoresizesSubviews = false
        cell.routeNameLabel.text = routeName
        cell.routeNumberLabel.text = routeNumberRT
        
        //println(cell)
        
        return cell
    }
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat {
        tableView.separatorColor = UIColor.whiteColor()
        return 100
    }
    
    //Remove Table Insets and Margins
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset.left = CGFloat(0.0)
        }
        if tableView.respondsToSelector("setLayoutMargins:") {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins.left = CGFloat(0.0)
        }
    }

    // UITableViewDelegate methods
    // Double check didSelectRowAtIndexPath VS didDeselectRowAtIndexPath
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cellRouteName: NSString?
        
        if let thisCell:RouteCell = tableView.cellForRowAtIndexPath(indexPath) as? RouteCell {
            self.routeNumber = thisCell.routeNumberLabel.text
            //println("You selected Route Number: \(rNum)")
            cellRouteName = thisCell.routeNameLabel.text
        }
        
        var displayDirections:DirectionsViewController = DirectionsViewController()
        displayDirections.routeNumber = self.routeNumber!
        displayDirections.title = NSString(string:"\(cellRouteName!)")
        
        self.navigationController?.pushViewController(displayDirections, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //Button Action
    func buttonAction(sender:UIButton!) {
        println("Button tapped")
    }

    
}
