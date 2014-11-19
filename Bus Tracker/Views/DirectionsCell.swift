//
//  DirectionsCell.swift
//  Bus Tracker
//
//  Created by Gerard Isaac on 10/30/14.
//  Copyright (c) 2014 Gerard Isaac. All rights reserved.
//

import UIKit

class DirectionsCell: UITableViewCell {
    
    var direction:NSString = NSString()
    var destination:NSString = NSString()
    var pID:NSString = NSString()
    
    var cellDirectionLabel:UILabel = UILabel()
    var cellDestinationLabel:UILabel = UILabel()
    var cellpIDLabel:UILabel = UILabel()
    
    var bgColorView: UIView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: reuseIdentifier)
        
        //println("Directions Cell Loaded")
        self.backgroundColor = UIColor.clearColor()
        
        let cellBgImage = UIImage(named:"directionsCellBg.png")!
        var cellBgImageView = UIImageView(frame: CGRectMake(0, 0, 320, 100))
        cellBgImageView.image = cellBgImage
        self.addSubview(cellBgImageView)
        
        self.backgroundColor = UIColor.clearColor()
        self.indentationLevel = 0
        self.indentationWidth = 0
        
        bgColorView.layer.zPosition = -1
        bgColorView.backgroundColor = uicolorFromHex(0x1077c6)
        bgColorView.alpha = 0.5
        self.addSubview(bgColorView)
        
        cellDirectionLabel.frame = CGRectMake( 70, 8, 250, 45)
        cellDirectionLabel.font = UIFont(name:"Gotham-Bold", size:33.0)
        cellDirectionLabel.textColor = uicolorFromHex(0xfffee8)
        cellDirectionLabel.textAlignment = NSTextAlignment.Left
        cellDirectionLabel.numberOfLines = 0
        cellDirectionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cellDirectionLabel.text = direction.uppercaseString
        self.addSubview(cellDirectionLabel)
        
        cellpIDLabel.frame = CGRectMake( 138, 46, 138, 16)
        cellpIDLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size:14.0)
        cellpIDLabel.textColor = UIColor.whiteColor()
        cellpIDLabel.textAlignment = NSTextAlignment.Left
        cellpIDLabel.text = pID
        self.addSubview(cellpIDLabel)
        
        cellDestinationLabel.frame = CGRectMake( 80, 74, 220, 26)
        cellDestinationLabel.font = UIFont(name:"HelveticaNeue-CondensedBold", size:14.0)
        cellDestinationLabel.textColor = uicolorFromHex(0xfffee8)
        cellDestinationLabel.textAlignment = NSTextAlignment.Left
        cellDestinationLabel.text = destination.uppercaseString
        self.addSubview(cellDestinationLabel)
    
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
    
    //Hex Color Values Function
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

}
