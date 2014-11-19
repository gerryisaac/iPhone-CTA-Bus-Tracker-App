//
//  DirectionsViewController.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/30/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class DirectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "cellIdentifier"
    var patternID:NSString? = NSString()
    
    var routeNumber:NSString = NSString()
    var directionsTable:UITableView = UITableView(frame: CGRectMake(0, 64, screenDimensions.screenWidth, screenDimensions.screenHeight - 64))
    
    //Directions Table Data Variables
    var directions: NSArray = []
    var directionsData: NSMutableArray = []
    var directionsCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //println("Get Directions")
        self.view.backgroundColor = UIColor.blueColor()
        
        //Create Background Image
        let bgImage = UIImage(named:"bg-DirectionsI5.png")
        var bgImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, screenDimensions.screenHeight))
        bgImageView.image = bgImage
        self.view.addSubview(bgImageView)
        
        retrieveDirections()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func retrieveDirections() {
        
        //Create Spinner
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.frame = CGRectMake(screenDimensions.screenWidth/2 - 25, screenDimensions.screenHeight/2 - 25, 50, 50);
        spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //spinner.backgroundColor = [UIColor blackColor];
        
        self.view.addSubview(spinner);
        spinner.startAnimating()
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/getpatterns?key=\(yourCTAkey.keyValue)&rt=\(routeNumber)"
        //println("Directions URL is \(feedURL)")
        
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
                
                //self.directions = rxml.children("dir")
                self.directions = rxml.children("ptr")
                self.directionsData.addObjectsFromArray(self.directions)
                self.directionsCount = self.directions.count
                
                if self.directionsCount == 0 {
                    
                    //println("No Data")
                    
                    var noDataLabel:UILabel = UILabel(frame: CGRectMake( 0, 200, screenDimensions.screenWidth, 75))
                    noDataLabel.font = UIFont(name:"Gotham-Bold", size:30.0)
                    noDataLabel.textColor = self.uicolorFromHex(0xfffee8)
                    noDataLabel.textAlignment = NSTextAlignment.Center
                    noDataLabel.numberOfLines = 0
                    noDataLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    noDataLabel.text = "No Data Available"
                    self.view.addSubview(noDataLabel)
                    
                } else {
                
                    var i:Int? = 0
                    for direction in self.directions {
                        i = i! + 1
                    }
                    //println(i!)
                    
                    //Create Direction Entries
                    self.directionsTable.backgroundColor = UIColor.clearColor()
                    self.directionsTable.dataSource = self
                    self.directionsTable.delegate = self
                    self.directionsTable.separatorInset = UIEdgeInsetsZero
                    self.directionsTable.layoutMargins = UIEdgeInsetsZero
                    self.directionsTable.bounces = true
                    
                    // Register the UITableViewCell class with the tableView
                    self.directionsTable.registerClass(DirectionsCell.self, forCellReuseIdentifier: self.cellIdentifier)
                    //self.patternTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
                    
                    //Add the Table View
                    self.view.addSubview(self.directionsTable)
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
        return self.directionsCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var appElement:RXMLElement = directionsData.objectAtIndex(indexPath.row) as RXMLElement
        var direction:NSString? = appElement.child("rtdir").text
        self.patternID = appElement.child("pid").text
        var subPoints: NSArray = []
        subPoints = appElement.children("pt")
        
        var subPointsData: NSMutableArray = []
        subPointsData.addObjectsFromArray(subPoints)
        
        var lastElement:RXMLElement = subPointsData.lastObject as RXMLElement
        var lastStopName:NSString? = lastElement.child("stpnm").text
        //println(lastElement)
        
        var cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as DirectionsCell
        
        if direction == nil {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.cellDirectionLabel.text = "No Stops Available"
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.cellDirectionLabel.text = direction
            cell.cellDestinationLabel.text = lastStopName?.uppercaseString
            cell.cellpIDLabel.text = self.patternID
        }
        
        cell.tintColor = UIColor.whiteColor()
        
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
        return 100
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // UITableViewDelegate methods
    //Double check didSelectRowAtIndexPath VS didDeselectRowAtIndexPath
    func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var  cellDirection: NSString?
        
        if let thisCell:DirectionsCell = tableView.cellForRowAtIndexPath(indexPath) as? DirectionsCell {
            self.patternID = thisCell.cellpIDLabel.text
            cellDirection = thisCell.cellDirectionLabel.text
        }
        
        var displayPatterns:patternDisplayViewController = patternDisplayViewController()
        displayPatterns.pID = self.patternID!
        displayPatterns.patternRequestNumber = self.routeNumber
        displayPatterns.title = NSString(string:"\(self.patternID!) \(cellDirection!)")
        
        self.navigationController?.pushViewController(displayPatterns, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //Hex Color Values Function
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
