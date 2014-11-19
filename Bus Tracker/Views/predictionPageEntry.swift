//
//  predictionPageEntry.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 11/6/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class predictionPageEntry: UIView {
    
    //Time Stamp
    var timeStampLabel: UILabel = UILabel()
    //Type
    var stopTypeLabel: UILabel = UILabel()
    //Stop Name
    var stopNameLabel: UILabel = UILabel()
    //Stop ID Number
    //var stopIDLabel: UILabel = UILabel()
    //Vehicle ID Number
    var vehicleIDLabel: UILabel = UILabel()
    //Distance to Stop
    var distanceStopLabel: UILabel = UILabel()
    //Route Number
    var routeNumLabel: UILabel = UILabel()
    //Route Direction
    var routeDirLabel: UILabel = UILabel()
    //Destination
    var destinationLabel: UILabel = UILabel()
    //Predicted Time
    var predictedTimeLabel: UILabel = UILabel()
    //Block ID
    var blockIDLabel: UILabel = UILabel()
    //Trip ID
    var tripIDLabel: UILabel = UILabel()
    //Bus Location Button
    var busLocation: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    func buildView() {
        
        var pageBgImage:UIImage = UIImage(named:"predictionsPageContentBg.png")!
        var pageBgPlaceholder:UIImageView = UIImageView(frame: CGRectMake(0, 0, 320, 416))
        pageBgPlaceholder.image = pageBgImage
        self.addSubview(pageBgPlaceholder)
        
        //Time Stamp
        timeStampLabel = UILabel(frame: CGRectMake(105, 5, 211, 20))
        timeStampLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        timeStampLabel.textColor = uicolorFromHex(0x95d1ff)
        timeStampLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(timeStampLabel)
        
        //Stop Name
        stopNameLabel = UILabel(frame: CGRectMake(50, 40, 250, 35))
        stopNameLabel.font = UIFont(name:"Gotham-Medium", size:22.0)
        stopNameLabel.textColor = UIColor.whiteColor()
        stopNameLabel.textAlignment = NSTextAlignment.Left
        stopNameLabel.numberOfLines = 0
        stopNameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.addSubview(stopNameLabel)
        
        //Type
        stopTypeLabel = UILabel(frame: CGRectMake(85, 89, 40, 20))
        stopTypeLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        stopTypeLabel.textColor = uicolorFromHex(0x95d1ff)
        stopTypeLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(stopTypeLabel)
        
        //Stop ID
        //stopIDLabel = UILabel(frame: CGRectMake(203, 66, 118, 20))

        //Trip ID
        tripIDLabel = UILabel(frame: CGRectMake(203, 89, 118, 20))
        tripIDLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        tripIDLabel.textColor = uicolorFromHex(0x95d1ff)
        tripIDLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(tripIDLabel)
        
        //Destination
        destinationLabel = UILabel(frame: CGRectMake(50, 113, 250, 35))
        destinationLabel.font = UIFont(name:"Gotham-Medium", size:22.0)
        destinationLabel.textColor = UIColor.whiteColor()
        destinationLabel.textAlignment = NSTextAlignment.Left
        destinationLabel.numberOfLines = 0
        destinationLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.addSubview(destinationLabel)
        
        //Distance to Stop
        distanceStopLabel = UILabel(frame: CGRectMake(203, 173, 118, 20))
        distanceStopLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        distanceStopLabel.textColor = uicolorFromHex(0x95d1ff)
        distanceStopLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(distanceStopLabel)
        
        //Route Number
        routeNumLabel = UILabel(frame: CGRectMake(85, 173, 35, 20))
        routeNumLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        routeNumLabel.textColor = uicolorFromHex(0x95d1ff)
        routeNumLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(routeNumLabel)
        
        //Route Direction
        routeDirLabel = UILabel(frame: CGRectMake(85, 197, 35, 20))
        routeDirLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        routeDirLabel.textColor = uicolorFromHex(0x95d1ff)
        routeDirLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(routeDirLabel)
        
        //Block ID
        blockIDLabel = UILabel(frame: CGRectMake(203, 197, 118, 20))
        blockIDLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        blockIDLabel.textColor = uicolorFromHex(0x95d1ff)
        blockIDLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(blockIDLabel)
        
        //Predicted Time
        predictedTimeLabel = UILabel(frame: CGRectMake(141, 237, 160, 33))
        predictedTimeLabel.font = UIFont(name:"Gotham-Bold", size:22.0)
        predictedTimeLabel.textColor = UIColor.whiteColor()
        predictedTimeLabel.textAlignment = NSTextAlignment.Left
        predictedTimeLabel.numberOfLines = 0
        predictedTimeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.addSubview(predictedTimeLabel)
        
        //Vehicle ID Number
        vehicleIDLabel = UILabel(frame: CGRectMake(190, 363, 90, 13))
        vehicleIDLabel.font = UIFont(name:"Gotham-Medium", size:12.0)
        vehicleIDLabel.textColor = uicolorFromHex(0x95d1ff)
        vehicleIDLabel.textAlignment = NSTextAlignment.Left
        self.addSubview(vehicleIDLabel)
        
        //Bus Location Button
        busLocation = UIButton(frame: CGRectMake(20, 290, 280, 70))
        
        let busButtonNormal = UIImage(named:"predictionBtnBusLocNormal.png")!
        let busButtonActive = UIImage(named:"predictionBtnBusLocHigh.png")!

        busLocation.setImage(busButtonNormal, forState: UIControlState.Normal)
        busLocation.setImage(busButtonActive, forState: UIControlState.Selected)
        busLocation.setImage(busButtonActive, forState: UIControlState.Highlighted)
        //busLocation.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(busLocation)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Hex Color Values Function
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
