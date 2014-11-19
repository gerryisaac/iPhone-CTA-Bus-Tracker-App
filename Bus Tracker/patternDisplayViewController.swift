//
//  patternDisplayViewController.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/28/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class patternDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "cellIdentifier"
    
    var patternRequestNumber:NSString = "0"
    var pID:NSString? = NSString()
    
    var textField:UITextView = UITextView()
    let patternTable: UITableView = UITableView(frame: CGRectMake(0, 128, 320, UIScreen.mainScreen().bounds.size.height - 128))
    
    //Header Components
    var pLength:NSString = "Loading..."
    var rtDir:NSString = "Loading..."
    
    //Header Labels
    var pIDDisplay: UILabel = UILabel()
    var pLengthDisplay: UILabel = UILabel()
    var rtDirDisplay: UILabel = UILabel()
    
    //Pattern Table Data Variables
    var patterns: NSArray = []
    var patternData: NSMutableArray = []
    var patternCount: Int = 0
    //var routeValue: NSString = "0"
    //var routeNumber: NSString? = "0"
    
    var tagValue:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //println("Pattern View for \(patternRequestNumber) Controller Loaded")
        self.view.backgroundColor = UIColor.redColor()
        
        //Create Background Image
        let bgImage = UIImage(named:"bg-MainI5.png")
        var bgImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, screenDimensions.screenHeight))
        bgImageView.image = bgImage
        bgImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(bgImageView)
        
        //Create Pattern Header
        let headerImage = UIImage(named:"header-Pattern.png")
        var headerImageView = UIImageView(frame: CGRectMake(0, 64, screenDimensions.screenWidth, 64))
        headerImageView.image = headerImage
        
        //Create Header Labels
        pIDDisplay.frame = CGRectMake(4, 29, 97, 25)
        pIDDisplay.font = UIFont(name: "HelveticaNeue-CondensedBold", size:15)
        pIDDisplay.textColor = UIColor.whiteColor()
        pIDDisplay.textAlignment = NSTextAlignment.Center
        pIDDisplay.text = pID
        headerImageView.addSubview(pIDDisplay)
        
        pLengthDisplay.frame = CGRectMake(109, 29, 97, 25)
        pLengthDisplay.font = UIFont(name: "HelveticaNeue-CondensedBold", size:15)
        pLengthDisplay.textColor = UIColor.whiteColor()
        pLengthDisplay.textAlignment = NSTextAlignment.Center
        pLengthDisplay.text = pLength.uppercaseString
        headerImageView.addSubview(pLengthDisplay)
        
        rtDirDisplay.frame = CGRectMake(213, 29, 103, 25)
        rtDirDisplay.font = UIFont(name: "HelveticaNeue-CondensedBold", size:15)
        rtDirDisplay.textColor = UIColor.whiteColor()
        rtDirDisplay.textAlignment = NSTextAlignment.Center
        rtDirDisplay.text = rtDir.uppercaseString
        headerImageView.addSubview(rtDirDisplay)
        
        self.view.addSubview(headerImageView)
        
        populatePatterns()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Retrieve Waypoints and Stops for this Route
    func populatePatterns(){
        
        //Create Spinner
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.frame = CGRectMake(screenDimensions.screenWidth/2 - 25, screenDimensions.screenHeight/2 - 25, 50, 50);
        spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //spinner.backgroundColor = [UIColor blackColor];
        
        self.view.addSubview(spinner);
        spinner.startAnimating()
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/getpatterns?key=\(yourCTAkey.keyValue)&rt=\(patternRequestNumber)"
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
                var mainXML:RXMLElement = rxml.child("*")
                
                var checker:NSString = NSString(string: mainXML.tag)
                
                /*Pattern Checker*/
                if checker.isEqualToString("error") {
                    
                    //Show Error
                    //Create Background Image
                    let bgImage = UIImage(named:"patternsCellNoticeBgI5.png")
                    var bgImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, screenDimensions.screenHeight))
                    bgImageView.image = bgImage
                    self.view.addSubview(bgImageView)
                    
                    self.textField = UITextView(frame:CGRectMake(0, screenDimensions.screenHeight/2 + 50, screenDimensions.screenWidth, 100))
                    self.textField.editable = false
                    self.textField.font = UIFont(name: "Gotham-Bold", size:18)
                    self.textField.textColor = UIColor.whiteColor()
                    self.textField.backgroundColor = UIColor.clearColor()
                    self.textField.scrollEnabled = true;
                    self.textField.text = NSString(string: mainXML.child("msg").text)
                    
                    self.view.addSubview(self.textField)
                    
                } else {
                    
                    //println("Start Patterns")
                    //Search Array and Look for the ID that matches Selection
                    
                    let searchString:NSString = "//ptr[pid="+self.pID!+"]"
                    rxml.iterateWithRootXPath(searchString, usingBlock: { appElement -> Void in
                        //println("Found")
                        
                        //PTR
                        var patternID:RXMLElement = appElement.child("pid")
                        var patternLength:RXMLElement = appElement.child("ln")
                        var patternDirection:RXMLElement = appElement.child("rtdir")
                        
                        self.pIDDisplay.text = patternID.text
                        self.pLengthDisplay.text = patternLength.text
                        self.rtDirDisplay.text = patternDirection.text.uppercaseString
                        
                        self.patterns = appElement.children("pt")
                        self.patternData.addObjectsFromArray(self.patterns)
                        self.patternCount = self.patternData.count
                        
                        //Create Pattern Entries
                        self.patternTable.backgroundColor = UIColor.clearColor()
                        self.patternTable.dataSource = self
                        self.patternTable.delegate = self
                        self.patternTable.separatorInset = UIEdgeInsetsZero
                        self.patternTable.layoutMargins = UIEdgeInsetsZero
                        
                        // Register the UITableViewCell class with the tableView
                        self.patternTable.registerClass(PatternCell.self, forCellReuseIdentifier: self.cellIdentifier)
                        //self.patternTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
                        
                        //Add the Table View
                        self.view.addSubview(self.patternTable)

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
    
    //Table View Configuration
    // Table Delegates and Data Source
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditing indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.patternCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var appElement:RXMLElement = patternData.objectAtIndex(indexPath.row) as RXMLElement
        
        var stopType:NSString? = appElement.child("typ").text
        var dist:NSString?
        var stopID:NSString?
        var stopName:NSString?
        
        var latValue:NSString? = appElement.child("lat").text
        var longValue:NSString? = appElement.child("lon").text
        var seq:NSString? = appElement.child("seq").text
        
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as PatternCell
        
        var checker:NSString = NSString(string:stopType!)
        
        /*Value Checker*/
        
        if checker.isEqualToString("W") {
            
            cell.cellBgImageViewColor.hidden = true
            cell.cellBgImageViewBW.hidden = false
            
            cell.cellstopType = "Waypoint"
            cell.cellstopTypeLabel.text = "ROUTE WAYPOINT"
            
            cell.cellstopID = "NONE"
            cell.cellstopIDLabel.text = "NONE"

            cell.cellstopName = "Bus Waypoint Only"
            cell.cellstopNameLabel.text = "Bus Waypoint Only"
            
            cell.iconWaypoint.hidden = false
            cell.iconBusStop.hidden = true
            
            cell.cellLatLabel.text = latValue!
            cell.cellLongLabel.text = longValue!
            
            cell.cellseqLabel.text = seq!
            cell.celldistLabel.text = "NONE"
            
            cell.timeButton.enabled = false
            cell.newsButton.enabled = false

        } else {
            
            stopID = appElement.child("stpid").text
            stopName = appElement.child("stpnm").text
            dist = appElement.child("pdist").text
            
            cell.cellBgImageViewColor.hidden = false
            cell.cellBgImageViewBW.hidden = true

            cell.cellstopType = "BUS STOP"
            cell.cellstopTypeLabel.text = "BUS STOP"

            cell.cellstopID = stopID!
            cell.cellstopIDLabel.text = stopID!

            cell.cellstopName = stopName!
            cell.cellstopNameLabel.text = stopName!
            
            cell.cellLatLabel.text = latValue!
            cell.cellLongLabel.text = longValue!
            
            cell.cellseqLabel.text = seq!
            cell.celldistLabel.text = dist!
            
            cell.iconWaypoint.hidden = true
            cell.iconBusStop.hidden = false
            
            //Add Time Button Tag
            //Extract Integer Value of Stop ID and Assign as Tags to Buttons
            self.tagValue = NSString(string: stopID!).integerValue
            //println(self.tagValue)
            
            cell.timeButton.tag = self.tagValue!
            cell.newsButton.tag = self.tagValue!
            
            cell.timeButton.enabled = true
            cell.newsButton.enabled = true
            
            cell.timeButton.addTarget(self, action: "timebuttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.newsButton.addTarget(self, action: "newsbuttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        return cell
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
    
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat {
        tableView.separatorColor = UIColor.whiteColor()
        return 200
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // UITableViewDelegate methods
    //Double check didSelectRowAtIndexPath VS didDeselectRowAtIndexPath
    //func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) { }
    
    //Time Button Action
    func timebuttonAction(sender:UIButton!) {
        
        //println("Time Button tapped")
        
        //Cast Self and Get Tag Number
        let button:UIButton = sender
        //println(button.tag)
        
        //Display Predictions for Selected Stop in this Route
        var displayPredictions:predictionDisplayViewController = predictionDisplayViewController()
        displayPredictions.stopNumber = String(button.tag)
        displayPredictions.routeNumber = self.patternRequestNumber
        displayPredictions.title = NSString(string:"Route: \(self.patternRequestNumber) Stop: \(button.tag)")
        
        self.navigationController?.pushViewController(displayPredictions, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    //News Button Action
    func newsbuttonAction(sender:UIButton!) {
        
        //println("News Button tapped")
        
        //Cast Self and Get Tag Number
        let button:UIButton = sender
        //println(button.tag)
        
        //Display Bulletins for Selected Stop in this Route
        var displayBulletins:bulletinDisplayViewController = bulletinDisplayViewController()
        displayBulletins.stopNumber = String(button.tag)
        displayBulletins.routeNumber = self.patternRequestNumber
        displayBulletins.title = NSString(string:"Route: \(self.patternRequestNumber) Stop: \(button.tag)")

        self.navigationController?.pushViewController(displayBulletins, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

}
