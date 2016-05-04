//
//  UIColor+ColorBetween.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 19-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func colorBetweenThisAnd(color: UIColor, atValue value: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromAlpha: CGFloat = 0
        
        self.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toBlue: CGFloat = 0
        var toGreen: CGFloat = 0
        var toAlpha: CGFloat = 0
        
        color.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let betweenRed = fromRed + (toRed - fromRed)*value
        let betweenBlue = fromBlue + (toBlue - fromBlue)*value
        let betweenGreen = fromGreen + (toGreen - fromGreen)*value
        
        
        return UIColor(red: betweenRed, green: betweenGreen, blue: betweenBlue, alpha: fromAlpha)
    }
}