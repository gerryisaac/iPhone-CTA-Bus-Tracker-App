//
//  PatternCell.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/29/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class PatternCell: UITableViewCell {
    
    //Pattern Values
    var cellBgImageViewColor:UIImageView = UIImageView()
    var cellBgImageViewBW:UIImageView = UIImageView()
    
    var cellstopType:NSString = NSString()
    var cellstopID:NSString = NSString()
    var cellstopName:NSString = NSString()
    
    var cellLat:NSString = NSString()
    var cellLong:NSString = NSString()
    
    var cellSequence:NSString = NSString()
    var cellDistance:NSString = NSString()
    
    //Pattern Labels
    var cellstopTypeLabel:UILabel = UILabel()
    var cellstopIDLabel:UILabel = UILabel()
    var cellstopNameLabel:UILabel = UILabel()
    
    var clatValueLabel:UILabel = UILabel()
    var clongValueLabel:UILabel = UILabel()
    
    var cellseqLabel:UILabel = UILabel()
    var celldistLabel:UILabel = UILabel()
    
    var cellLatLabel:UILabel = UILabel()
    var cellLongLabel:UILabel = UILabel()
    
    var iconBusStop:UIImageView = UIImageView()
    var iconWaypoint:UIImageView = UIImageView()
    
    var iconOnline:UIImageView = UIImageView()
    var iconOffline:UIImageView = UIImageView()

    var routeNumberLabel:UILabel = UILabel()
    var routeNameLabel:UILabel = UILabel()
    
    var timeButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    var newsButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        //println("Cell Loaded")
        
        //Create Cell Background
        self.backgroundColor = UIColor.clearColor()
        let cellBgImage = UIImage(named:"patternsCellBgLarge.png")!
        cellBgImageViewColor = UIImageView(frame: CGRectMake(0, 0, 320, 200))
        cellBgImageViewColor.image = cellBgImage
        cellBgImageViewColor.hidden = true
        //cellBgImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.addSubview(cellBgImageViewColor)
        
        let cellBgImageBW = UIImage(named:"patternsCellBgLargeBW.png")!
        cellBgImageViewBW = UIImageView(frame: CGRectMake(0, 0, 320, 200))
        cellBgImageViewBW.image = cellBgImageBW
        cellBgImageViewBW.hidden = true
        
        self.addSubview(cellBgImageViewBW)
        
        cellstopTypeLabel.frame = CGRectMake(3, 3, 157, 20)
        cellstopTypeLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size:14.0)
        cellstopTypeLabel.textColor = UIColor.whiteColor()
        cellstopTypeLabel.textAlignment = NSTextAlignment.Center
        cellstopTypeLabel.text = cellstopType.uppercaseString
        self.addSubview(cellstopTypeLabel)
        
        cellstopIDLabel.frame = CGRectMake(160, 3, 157, 20)
        cellstopIDLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size:14.0)
        cellstopIDLabel.textColor = UIColor.whiteColor()
        cellstopIDLabel.textAlignment = NSTextAlignment.Center
        cellstopIDLabel.text = cellstopID
        self.addSubview(cellstopIDLabel)
        
        cellstopNameLabel.frame = CGRectMake(6, 23, 314, 67)
        cellstopNameLabel.font = UIFont(name:"Gotham-Medium", size:25.0)
        cellstopNameLabel.textColor = UIColor.whiteColor()
        cellstopNameLabel.textAlignment = NSTextAlignment.Left
        cellstopNameLabel.numberOfLines = 0
        cellstopNameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cellstopNameLabel.text = cellstopName
        self.addSubview(cellstopNameLabel)
        
        cellLatLabel.frame = CGRectMake(103, 96, 142, 20)
        cellLatLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        cellLatLabel.textColor = uicolorFromHex(0x828282)
        cellLatLabel.textAlignment = NSTextAlignment.Left
        cellLatLabel.text = cellLat
        self.addSubview(cellLatLabel)
        
        cellLongLabel.frame = CGRectMake(103, 119, 142, 20)
        cellLongLabel.font = UIFont(name:"Gotham-Medium", size:14.0)
        cellLongLabel.textColor = uicolorFromHex(0x828282)
        cellLongLabel.textAlignment = NSTextAlignment.Left
        cellLongLabel.text = cellLong
        self.addSubview(cellLongLabel)
        
        cellseqLabel.frame = CGRectMake(121, 148, 54, 15)
        cellseqLabel.font = UIFont(name:"Gotham-Bold", size:12.0)
        cellseqLabel.textColor = uicolorFromHex(0x828282)
        cellseqLabel.textAlignment = NSTextAlignment.Left
        cellseqLabel.text = cellSequence
        self.addSubview(cellseqLabel)
        
        celldistLabel.frame = CGRectMake(121, 176, 54, 15)
        celldistLabel.font = UIFont(name:"Gotham-Bold", size:12.0)
        celldistLabel.textColor = uicolorFromHex(0x828282)
        celldistLabel.textAlignment = NSTextAlignment.Left
        celldistLabel.text = cellDistance
        self.addSubview(celldistLabel)

        //Bus Stop Icon
        let busStopImage = UIImage(named:"patternCell-IconStop.png")!
        iconBusStop = UIImageView(frame: CGRectMake(3, 142, 55, 55))
        iconBusStop.image = busStopImage
        iconBusStop.hidden = true
        self.addSubview(iconBusStop)
        
        //Waypoint Icon
        let waypointImage = UIImage(named:"patternCell-IconWayPoint.png")!
        iconWaypoint = UIImageView(frame: CGRectMake(3, 142, 55, 55))
        iconWaypoint.image = waypointImage
        iconWaypoint.hidden = true
        self.addSubview(iconWaypoint)
        
        //Online and Offline Icons
        let onlineImage = UIImage(named:"patternCell-footerOnline.png")!
        let offlineImage = UIImage(named:"patternCell-footerOffline.png")!
        
        iconOnline = UIImageView(frame: CGRectMake(248, 96, 69, 20))
        iconOnline.image = onlineImage
        iconOnline.hidden = false
        self.addSubview(iconOnline)
        
        iconOffline = UIImageView(frame: CGRectMake(248, 119, 69, 20))
        iconOffline.image = offlineImage
        iconOffline.hidden = false
        self.addSubview(iconOffline)
        
        //Create Buttons
        let timeButtonNormal = UIImage(named:"patternBtn-TimeNormal.png")!
        let timeButtonActive = UIImage(named:"patternBtn-TimeOver.png")!
        let timeButtonDisabled = UIImage(named:"patternBtn-TimeDisabled.png")!
        
        let newsButtonNormal = UIImage(named:"patternBtn-NewsNormal.png")!
        let newsButtonActive = UIImage(named:"patternBtn-NewsOver.png")!
        let newsButtonDisabled = UIImage(named:"patternBtn-NewsDisabled.png")!
        
        timeButton.frame = CGRectMake(176, 142, 69, 55)
        timeButton.setImage(timeButtonNormal, forState: UIControlState.Normal)
        timeButton.setImage(timeButtonActive, forState: UIControlState.Highlighted)
        timeButton.setImage(timeButtonDisabled, forState: UIControlState.Disabled)
        //timeButton.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(timeButton)
        
        newsButton.frame = CGRectMake(248, 142, 69, 55)
        newsButton.setImage(newsButtonNormal, forState: UIControlState.Normal)
        newsButton.setImage(newsButtonActive, forState: UIControlState.Highlighted)
        newsButton.setImage(newsButtonDisabled, forState: UIControlState.Disabled)
        //newsButton.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(newsButton)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //Hex Color Values Function
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
