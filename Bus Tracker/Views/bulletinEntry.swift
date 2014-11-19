//
//  bulletinEntry.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 11/13/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class bulletinEntry: UIView {
    
    //Bulletin Name
    var bEntryName:NSString = "Test"
    //Bulletin Subject
    var bEntrySubject :NSString = "Test"
    //Bulletin Detail
    var bEntryDetail :NSString = "Test"
    //Bulletin Priority
    var bEntryPriority :NSString = "Test"
    
    var nameLabel: UILabel = UILabel()
    var subjectLabel: UILabel = UILabel()
    var detailsText: UITextView = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.buildView()
    }
    
    func buildView(){
        //Create Background Image
        let bgImage = UIImage(named:"bulletinEntryBgI5.png")!
        var bgImageView = UIImageView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, 504))
        bgImageView.image = bgImage
        self.addSubview(bgImageView)
        
        nameLabel.frame = CGRectMake(18, 33, 287, 55)
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.font = UIFont(name:"Gotham-Medium", size:18.0)
        nameLabel.textAlignment = NSTextAlignment.Left
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        nameLabel.textColor = UIColor.whiteColor()
        var nameString:NSString = bEntryName
        var strippedName:NSString = nameString.stripHtml()
        nameLabel.text = strippedName//.capitalizedString
        self.addSubview(nameLabel)
        
        subjectLabel.frame = CGRectMake(18, 126, 287, 50)
        subjectLabel.backgroundColor = UIColor.clearColor()
        subjectLabel.font = UIFont(name:"Gotham-Medium", size:15.0)
        subjectLabel.textAlignment = NSTextAlignment.Left
        subjectLabel.numberOfLines = 0
        subjectLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        subjectLabel.textColor = UIColor.whiteColor()
        var subjectString:NSString = bEntrySubject
        var strippedSubject:NSString = subjectString.stripHtml()
        subjectLabel.text = strippedSubject//.capitalizedString
        self.addSubview(subjectLabel)
        
        detailsText.frame = CGRectMake(15, 214, 290, 157)
        subjectLabel.backgroundColor = UIColor.clearColor()
        detailsText.font = UIFont(name:"Gotham-Medium", size:15.0)
        detailsText.backgroundColor = UIColor.clearColor()
        detailsText.textAlignment = NSTextAlignment.Left
        detailsText.scrollEnabled = true
        //detailsText.numberOfLines = 0
        //detailsText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        detailsText.textColor = UIColor.whiteColor()
        var detailString:NSString = bEntryDetail
        var strippedDetail:NSString = detailString.stripHtml()
        detailsText.text = strippedDetail//.capitalizedString
        self.addSubview(detailsText)
        
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
