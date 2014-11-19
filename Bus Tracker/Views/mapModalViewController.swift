//
//  mapModalViewController.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 11/6/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit
import MapKit

class mapModalViewController: UIViewController, MKMapViewDelegate {
    
    var dismissButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    
    var busID:NSString?
    var destination:NSString?
    var routeNum:NSString?
    
    var latNum:NSString?
    var vLatValue:Float?
    
    var longNum:NSString?
    var vLongValue:Float?
    
    var headingNum:NSString?
    var headingValue:Int?
    
    var distanceNum:NSString?
    var tatripNum:NSString?
    var tablockID:NSString?

    var busIDLabel:UILabel = UILabel()
    var destinationLabel:UILabel = UILabel()
    var routeNumLabel:UILabel = UILabel()
    var headingNumLabel:UILabel = UILabel()
    var distanceNumLabel:UILabel = UILabel()
    var tatripNumLabel:UILabel = UILabel()
    var tablockIDLabel:UILabel = UILabel()
    var flagOntime:UIImageView = UIImageView()
    var flagDelayed:UIImageView = UIImageView()
    
    var mapView:MKMapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set our transition style
        modalTransitionStyle = UIModalTransitionStyle.CoverVertical

        self.view.backgroundColor = UIColor.blackColor()
        var pageBgImage:UIImage = UIImage(named:"busLocationBgI5.png")!
        var pageBgPlaceholder:UIImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, screenDimensions.screenHeight))
        pageBgPlaceholder.image = pageBgImage
        self.view.addSubview(pageBgPlaceholder)
        
        let flagOntimeImage:UIImage = UIImage(named:"busLocationFlagOnTime.png")!
        let flagDelayedImage:UIImage = UIImage(named:"busLocationFlagDelayed.png")!
        
        flagOntime = UIImageView(frame: CGRectMake(10, 430, 147.5, 40))
        flagOntime.image = flagOntimeImage
        flagOntime.hidden = true
        self.view.addSubview(flagOntime)
        
        flagDelayed = UIImageView(frame: CGRectMake(162.5, 430, 147.5, 40))
        flagDelayed.image = flagDelayedImage
        flagDelayed.hidden = true
        self.view.addSubview(flagDelayed)
        
        let closeButtonNormal = UIImage(named:"busLocationBtnCloseN.png")!
        let closeButtonActive = UIImage(named:"busLocationBtnCloseH.png")!
        
        dismissButton.frame = CGRectMake(260, 30, 50, 50)
        dismissButton.setImage(closeButtonNormal, forState: UIControlState.Normal)
        dismissButton.setImage(closeButtonActive, forState: UIControlState.Highlighted)
        dismissButton.addTarget(self, action: "closeMap", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(dismissButton)
        
        self.retrieveData(busID!)
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //println("Appeared")
        //self.view.bounds = CGRectMake(0, 20, 320, 460)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retrieveData(busNum:NSString){
        
        //Create Spinner
        var spinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.frame = CGRectMake(screenDimensions.screenWidth/2 - 25, screenDimensions.screenHeight/2 - 25, 50, 50);
        spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
        //spinner.backgroundColor = [UIColor blackColor];
        
        self.view.addSubview(spinner);
        spinner.startAnimating()
        
        //Load Bus Tracker Data
        let feedURL:NSString = "http://www.ctabustracker.com/bustime/api/v1/getvehicles?key=\(yourCTAkey.keyValue)&vid=\(busID!)"
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
                //println(rxml)
                
                var rootXML:RXMLElement = rxml.child("*")
                
                var checker:NSString = rootXML.tag
                //println(checker)
                
                /*Pattern Checker*/
                if checker.isEqualToString("error") {
                    
                    let searchString:NSString = "//msg"
                    rxml.iterateWithRootXPath(searchString, usingBlock: { appElement -> Void in
                        //println(appElement.text)
                        //println("ELSE Response:\(responseString)")
                        
                        //Create Background Image
//                        let bgImage = UIImage(named:"patternsCellNoticeBg.png")
//                        var bgImageView = UIImageView(frame: CGRectMake(0, 0, 320, 480))
//                        bgImageView.image = bgImage
//                        self.view.addSubview(bgImageView)
                        
                        var txtField: UILabel = UILabel(frame:CGRectMake(screenDimensions.screenWidth/2 - 110, screenDimensions.screenHeight/2 - 150, 220, 100))
                        txtField.backgroundColor = UIColor.clearColor()
                        txtField.font = UIFont(name:"Gotham-Light", size:25.0)
                        txtField.textAlignment = NSTextAlignment.Center
                        txtField.numberOfLines = 0
                        txtField.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        txtField.textColor = UIColor.whiteColor()
                        var message:NSString = appElement.text
                        txtField.text = message.capitalizedString
                        self.view.addSubview(txtField)
                    })
                    
                    
                } else {
                    
                    var subrootXML:RXMLElement = rxml.child("vehicle")
                    
                    self.busID = subrootXML.child("vid").text
                    
                    var timeStamp:RXMLElement = subrootXML.child("tmstmp")
                    
                    self.destination = subrootXML.child("des").text
                    
                    self.routeNum = subrootXML.child("pid").text
                    
                    self.latNum = subrootXML.child("lat").text
                    self.vLatValue = (self.latNum! as NSString).floatValue
                    
                    self.longNum = subrootXML.child("lon").text
                    self.vLongValue = (self.longNum! as NSString).floatValue
                    
                    self.headingNum = subrootXML.child("hdg").text
                    self.headingValue = (self.headingNum! as NSString).integerValue
                    
                    self.distanceNum = subrootXML.child("pdist").text
                    
                    self.tatripNum = subrootXML.child("tatripid").text
                    
                    self.tablockID = subrootXML.child("tablockid").text
                    
                    //println("Bus ID:\(self.busID) Time Stamp:\(timeStamp) Destination:\(self.destination) Route Number:\(self.routeNum) Latitude:\(self.latNum) LAT Float:\(self.vLatValue) Longitude:\(self.longNum) LONG Float:\(self.vLongValue) Heading:\(self.headingNum) Heading Integer:\(self.headingValue) Distance:\(self.distanceNum) TA Trip ID:\(self.tatripNum) TA Block ID:\(self.tablockID)")
                    
                    self.buildBusLocation(self.busID!, bdestination: self.destination!, brouteNum: self.routeNum!, bheadingNum: self.headingNum!, btatripNum: self.tatripNum!, bdistanceNum: self.distanceNum!, btablockID: self.tablockID!, blatValue:self.vLatValue!, blongValue:self.vLongValue!)
                    
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
    
    func buildBusLocation(
        bbusID:NSString,
        bdestination:NSString,
        brouteNum:NSString,
        bheadingNum:NSString,
        btatripNum:NSString,
        bdistanceNum:NSString,
        btablockID:NSString,
        blatValue:Float,
        blongValue:Float){
            
            busIDLabel.frame = CGRectMake(109, 40, 140, 35)
            busIDLabel.font = UIFont(name:"Gotham-Medium", size:36.0)
            busIDLabel.textColor = UIColor.whiteColor()
            busIDLabel.textAlignment = NSTextAlignment.Left
            //busIDLabel.numberOfLines = 0
            //busIDLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            busIDLabel.text = bbusID
            self.view.addSubview(busIDLabel)
            
            destinationLabel.frame = CGRectMake(109, 82, 150, 25)
            destinationLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
            destinationLabel.textColor = UIColor.whiteColor()
            destinationLabel.textAlignment = NSTextAlignment.Left
            destinationLabel.text = bdestination
            self.view.addSubview(destinationLabel)
            
            routeNumLabel.frame = CGRectMake(260, 82, 50, 25)
            routeNumLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
            routeNumLabel.textColor = UIColor.whiteColor()
            routeNumLabel.textAlignment = NSTextAlignment.Center
            routeNumLabel.text = brouteNum
            self.view.addSubview(routeNumLabel)
            
            headingNumLabel.frame = CGRectMake(90, 382, 55, 20)
            headingNumLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
            headingNumLabel.textColor = UIColor.whiteColor()
            headingNumLabel.textAlignment = NSTextAlignment.Left
            headingNumLabel.text = bheadingNum
            self.view.addSubview(headingNumLabel)
            
            tatripNumLabel.frame = CGRectMake(90, 406, 55, 20)
            tatripNumLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
            tatripNumLabel.textColor = UIColor.whiteColor()
            tatripNumLabel.textAlignment = NSTextAlignment.Left
            tatripNumLabel.text = btatripNum
            self.view.addSubview(tatripNumLabel)
            
            distanceNumLabel.frame = CGRectMake(237, 382, 75, 20)
            distanceNumLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
            distanceNumLabel.textColor = UIColor.whiteColor()
            distanceNumLabel.textAlignment = NSTextAlignment.Left
            distanceNumLabel.text = bdistanceNum
            self.view.addSubview(distanceNumLabel)
            
            tablockIDLabel.frame = CGRectMake(237, 406, 75, 20)
            tablockIDLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
            tablockIDLabel.textColor = UIColor.whiteColor()
            tablockIDLabel.textAlignment = NSTextAlignment.Left
            tablockIDLabel.text = btablockID
            self.view.addSubview(tablockIDLabel)
            
            self.flagOntime.hidden = false
            self.flagDelayed.hidden = true
            
            //Display Bus Location in Map
            //println("Latitude:\(blatValue) Longitude:\(blongValue)")
            
            var mapPlaceHolder:UIView = UIView(frame: CGRectMake(10, 110, 300, 265))
            mapPlaceHolder.backgroundColor = UIColor.redColor()
            
            self.mapView = MKMapView(frame:CGRectMake(0, 0, 300, 265))
            self.mapView.delegate = self
            self.mapView.mapType = MKMapType.Standard
            self.mapView.zoomEnabled = true
            self.mapView.scrollEnabled = true
            //self.mapView.showsUserLocation = false
            
            var centerCoord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:Double(blatValue), longitude:Double(blongValue))
            
            //let span = MKCoordinateSpanMake(0.00725, 0.00725)
            //let region = MKCoordinateRegion(center: centerCoord, span: span)
            let region = MKCoordinateRegionMakeWithDistance(centerCoord, 200, 200)
            self.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.setCoordinate(centerCoord)
            //annotation.title = "Big Ben"
            //annotation.subtitle = "London"
            mapView.addAnnotation(annotation)
            
            mapPlaceHolder.addSubview(self.mapView)
            self.view.addSubview(mapPlaceHolder)
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        let viewId:NSString = "MKPinAnnotationView"
    
        var annotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(viewId)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:viewId)
            // set your custom image
            annotationView.image = UIImage(named:"busPinTemp.png")
            //annotationView.calloutOffset = CGPointMake(0, 0)
        }
        return annotationView;
    }
    
    func closeMap(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Hex Color Values Function
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
