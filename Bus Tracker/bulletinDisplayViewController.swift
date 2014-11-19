//
//  bulletinDisplayViewController.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 11/12/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class bulletinDisplayViewController: UIViewController, UIScrollViewDelegate {
    
    var routeNumber:NSString? = NSString()
    var stopNumber:NSString? = NSString()
    var tagValue:Int?
    
    //Variable to Hold Scroll Data
    var bulletins: NSArray = []
    var bulletinData: NSMutableArray =  []
    var bulletinCount: Int = 0
    
    //Scroll View
    var mainScroll:UIScrollView = UIScrollView()
    var pageControl:UIPageControl = UIPageControl()
    
    var rxml:RXMLElement = RXMLElement()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.greenColor()
        
        var bgImage:UIImage = UIImage(named:"predictionsScrollBg.png")!
        var bgPlaceholder:UIImageView = UIImageView(frame: CGRectMake(0, 64, screenDimensions.screenWidth, screenDimensions.screenHeight - 64))
        bgPlaceholder.image = bgImage
        self.view.addSubview(bgPlaceholder)
        
        //Run Data Function
        populateBulletins(routeNumber!,stopNum: stopNumber!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Retrieve Data for Selected Stop in this Route
    func populateBulletins(routeNum: NSString, stopNum: NSString) {
        
        //Create Spinner
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.frame = CGRectMake(screenDimensions.screenWidth/2 - 25, screenDimensions.screenHeight/2 - 25, 50, 50);
        spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //spinner.backgroundColor = [UIColor blackColor];
        
        self.view.addSubview(spinner);
        spinner.startAnimating()
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/getservicebulletins?key=\(yourCTAkey.keyValue)&stpid=\(stopNum)"
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
                //println(self.rxml)
                
                var mainXML:RXMLElement = self.rxml.child("*")
                
                var checker:NSString = mainXML.tag
                //println(checker)
                
                /*Pattern Checker*/
                if checker.isEqualToString("sb") {
                    
                    //println("Build Scrollview")
                    //println("EQUAL Response:\(responseString)")
                    
                    self.bulletins = self.rxml.children("sb")
                    self.bulletinData.addObjectsFromArray(self.bulletins)
                    self.bulletinCount = self.bulletinData.count
                    //println(self.bulletins)
                    //println(self.bulletinCount)
                    
                    self.createScrollDataScreen(self.bulletinCount)
                    
                    
                } else {
                    
                    let searchString:NSString = "//msg"
                    self.rxml.iterateWithRootXPath(searchString, usingBlock: { appElement -> Void in
                        //println(appElement.text)
                        //println("ELSE Response:\(responseString)")
                        
                        //Create Background Image
                        let bgImage = UIImage(named:"patternsCellNoticeBgI5.png")
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
        let fixedHeight:CGFloat = 504.0
        
        var scrollViewFrame:CGRect = CGRectMake(0, 64, screenDimensions.screenWidth, fixedHeight)
        
        self.mainScroll = UIScrollView(frame: scrollViewFrame)
        self.mainScroll.backgroundColor = UIColor.clearColor()
        
        //Set delegate
        self.mainScroll.delegate = self
        self.mainScroll.pagingEnabled = true
        self.mainScroll.showsHorizontalScrollIndicator = true
        
        var scrollContent:UIView = UIView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, fixedHeight))
        scrollContent.frame = CGRectMake(0, 0, screenDimensions.screenWidth * CGFloat(pageCount), fixedHeight)
        
        //Bulletin Name
        var bulletinName:NSString?
        //Bulletin Subject
        var bulletinSubject :NSString?
        //Bulletin Detail
        var bulletinDetail :NSString?
        //Bulletin Priority
        var bulletinPriority :NSString?
        
        var rootXML:RXMLElement = self.rxml.child("sb")
        
        rootXML.iterateElements(self.bulletins, usingBlock: { appElement -> Void in
            
            bulletinName = appElement.child("nm").text.stripHtml()
            bulletinSubject = appElement.child("sbj").text.stripHtml()
            bulletinDetail = appElement.child("dtl").text.stripHtml()
            bulletinPriority = appElement.child("prty").text.stripHtml()
            
            //println("Bulletin Name:\(bulletinName) Bulletin Subject:\(bulletinSubject) Bulletin Details:\(bulletinDetail) Bulletin Priority:\(bulletinPriority)")
            
            //Create ScrollView Content and add Pages for Holding the Data
            var xLocation:CGFloat = 0.0
            
            var pageEntry: bulletinEntry = bulletinEntry(frame:CGRectMake(xLocation + currentWidth, 0, screenDimensions.screenWidth, 504))
            
            pageEntry.nameLabel.text = bulletinName!
            pageEntry.subjectLabel.text = bulletinSubject!
            pageEntry.detailsText.text = bulletinDetail!
            pageEntry.bEntryPriority = bulletinPriority!
            
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
    

}
