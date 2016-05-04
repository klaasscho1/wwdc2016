//
//  AppIconView.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 23-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

let ICON_SIZE: CGFloat = 60
let ICON_RADIUS: CGFloat = 13.5
let ICONS_IN_ROW: CGFloat = 4
let VERTICAL_SPACING: CGFloat = 30

class AppIconView: UIView {
    var index: Int!
    var name: String!
    
    init(inRow row: Int, inColumn column: Int, withIcon icon: UIImage, andName name: String) {
        self.name = name
        
        let spacing: CGFloat = (UIScreen.mainScreen().bounds.width - (ICONS_IN_ROW * ICON_SIZE))/5
        var frame = CGRectZero
        
        frame.size.height = ICON_SIZE + VERTICAL_SPACING
        frame.size.width = ICON_SIZE
        
        if row != -1 {
            frame.origin.x = spacing+(CGFloat(column-1) * (spacing + ICON_SIZE))
            frame.origin.y = VERTICAL_SPACING + (CGFloat(row-1) * (ICON_SIZE + VERTICAL_SPACING))
        } else {
            frame.origin.y = UIScreen.mainScreen().bounds.height-90+((90-(ICON_SIZE+VERTICAL_SPACING))/2)+5
            frame.origin.x = UIScreen.mainScreen().bounds.width/2-(ICON_SIZE/2)
        }
        
        super.init(frame: frame)
        
        let iconImage = UIImageView(frame: CGRectMake(0, 0, ICON_SIZE, ICON_SIZE))
        iconImage.image = icon
        iconImage.layer.cornerRadius = ICON_RADIUS
        iconImage.layer.masksToBounds = true
        iconImage.clipsToBounds = true
        
        self.addSubview(iconImage)
        
        let titleLabel = UILabel(frame: CGRectMake(-10, ICON_SIZE, ICON_SIZE+20, VERTICAL_SPACING-5))
        titleLabel.text = name
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(12)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
