//
//  RouteCell.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/28/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {

    var routeNumberLabel:UILabel = UILabel()
    var routeNameLabel:UILabel = UILabel()
    var bgColorView: UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        //println("Cell Loaded")
        
        var nameFont = UIFont(name:"Gotham-Bold", size:20.0)
        var numberFont = UIFont(name:"HelveticaNeue-CondensedBold", size:15.0)
        
        self.backgroundColor = UIColor.clearColor()
        self.indentationLevel = 0
        self.indentationWidth = 0
        
        bgColorView.layer.zPosition = -1
        bgColorView.backgroundColor = UIColor.blackColor()
        bgColorView.alpha = 0.5
        self.addSubview(bgColorView)
        
        var cellHolder = UIView(frame: CGRectMake(0, 0, screenDimensions.screenWidth, 100))
        cellHolder.backgroundColor = UIColor.clearColor()
        cellHolder.layer.zPosition = 1
        
        routeNameLabel.frame = CGRectMake(100, 10, 210, 50)
        routeNameLabel.font = nameFont
        routeNameLabel.textColor = UIColor.whiteColor()
        routeNameLabel.textAlignment = NSTextAlignment.Left
        routeNameLabel.numberOfLines = 0
        routeNameLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        routeNameLabel.backgroundColor = UIColor.clearColor()
        cellHolder.addSubview(routeNameLabel)
        
        routeNumberLabel.frame = CGRectMake(100, 70, 210, 20)
        routeNumberLabel.font = numberFont
        routeNumberLabel.textColor = UIColor.whiteColor()
        routeNumberLabel.backgroundColor = UIColor.clearColor()
        cellHolder.addSubview(routeNumberLabel)
        
        let thumbTempImage = UIImage(named:"routeIcon.png")
        var imageThumb = UIImageView(frame: CGRectMake(10, 10, 80, 80))
        imageThumb.image = thumbTempImage
        
        cellHolder.addSubview(imageThumb)
        
        self.addSubview(cellHolder)
        
        routeNameLabel.text = "Test"
        routeNumberLabel.text = "Test"

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
        //Set Background Color when highlighted
        self.selectedBackgroundView = bgColorView
    }

}
