//
//  PulsingTouchView.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 19-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import Foundation
import UIKit

protocol PulsingTouchViewDelegate {
    func forceTouchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    func forceTouchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    func forceTouchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    func forceTouchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
}

let MIN_SCALE: CGFloat = 0.8
let MAX_SCALE: CGFloat = 1.0

class PulsingTouchView: UIView {
    var innerCircle: UIView!
    var pulsingCircle: UIView!
    var timer: NSTimer!
    var shouldPulse = true
    var shouldMeasureForce = false
    var delegate: PulsingTouchViewDelegate?
    var maskableView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, 100, 100))
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        self.innerCircle = UIView(frame: CGRectMake(0, 0, 100, 100))
        innerCircle.backgroundColor = UIColor.whiteColor()
        innerCircle.layer.cornerRadius = innerCircle.frame.height/2
        innerCircle.clipsToBounds = true
        innerCircle.layer.masksToBounds = false
        
        let gradientView = UIView(frame: CGRectMake(0,0,100,100))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = innerCircle.bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.lightGrayColor().CGColor]
        gradient.locations = [0.5, 2.5]
        gradientView.layer.insertSublayer(gradient, atIndex: 0)
        gradientView.layer.cornerRadius = innerCircle.frame.height/2
        gradientView.clipsToBounds = true
        
        //self.innerCircle.addSubview(gradientView)
        
        self.pulsingCircle = UIView(frame: CGRectMake(0, 0, 100, 100))
        pulsingCircle.backgroundColor = UIColor.whiteColor()
        pulsingCircle.layer.cornerRadius = pulsingCircle.frame.height/2
        
        self.addSubview(self.innerCircle)
        self.addSubview(self.pulsingCircle)
        self.sendSubviewToBack(self.pulsingCircle)
        
        pulseOnce()
    }
    
    func pulseOnce() {
        innerCircle.transform = CGAffineTransformMakeScale(1.0, 1.0)
        pulsingCircle.transform = CGAffineTransformMakeScale(0.5, 0.5)
        pulsingCircle.alpha = 0.8
        
        UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseInOut, animations: {
            
            self.innerCircle.transform = CGAffineTransformMakeScale(MIN_SCALE, MIN_SCALE)
            
            }) { (bool) in
                if self.shouldPulse {
                    UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseInOut, animations: {
                        
                        self.innerCircle.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        
                    }) { (bool) in
                        if self.shouldPulse {
                            self.pulseOnce()
                        }
                    }
                }
        }
        
        
        UIView.animateWithDuration(1.8, delay: 0.2, options: .CurveEaseInOut, animations: {
            
            self.pulsingCircle.transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.pulsingCircle.alpha = 0.0
            
        }, completion: nil)
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in self.subviews {
            if subview.hitTest(self.convertPoint(point, toView:subview), withEvent:event) != nil {
                return true
            }
        }
        
        return false
    }
    
    func stopAnimation() {
        innerCircle.layer.removeAllAnimations()
        pulsingCircle.layer.removeAllAnimations()
        
        self.innerCircle.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.innerCircle.layer.shadowOffset = CGSizeMake(0, 0)
        self.innerCircle.layer.shadowRadius = 0.0
        self.innerCircle.layer.shadowOpacity = 0.0
        
        pulsingCircle.transform = CGAffineTransformMakeScale(0.5, 0.5)
        pulsingCircle.alpha = 0.0
        shouldPulse = false
        
        UIView.animateWithDuration(0.3, animations: {
            self.innerCircle.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.innerCircle.layer.shadowOffset = CGSizeMake(0, 20)
            self.innerCircle.layer.shadowRadius = 20
            self.innerCircle.layer.shadowOpacity = 0.5
            }) { (bool) in
                self.shouldMeasureForce = true
        }

    }
    
    func resumeAnimation() {
        shouldPulse = true
        maskableView?.layer.mask = nil
        UIView.animateWithDuration(0.5, animations: {
            self.innerCircle.backgroundColor = UIColor.whiteColor()
            self.innerCircle.layer.shadowOpacity = 0.0
            }) { (bool) in
                self.pulseOnce()
        }
    }
    
    func setTouchForce(force: CGFloat) {
        print("Set Touch Force")
        if shouldMeasureForce {
            print("Do This")
            let scale = MAX_SCALE - (MAX_SCALE - MIN_SCALE) * force
            innerCircle.transform = CGAffineTransformMakeScale(scale, scale)
            innerCircle.layer.shadowColor = UIColor.blackColor().CGColor
            innerCircle.layer.shadowOffset = CGSizeMake(0, 20 - (20*force))
            innerCircle.layer.shadowRadius = 20 - (10 * force)
            innerCircle.layer.shadowOpacity = 0.5 - (0.5 * Float(force))
            
            let maskLayer = CAShapeLayer()
            
            // Create a path with the rectangle in it.
            let path = CGPathCreateMutable()
            
            let radius : CGFloat = force * UIScreen.mainScreen().bounds.height
            
            CGPathAddArc(path, nil, UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height-100, radius, 0.0, 2*3.14, false)
            CGPathAddRect(path, nil, CGRectMake(0, 0, maskableView!.frame.width, maskableView!.frame.height))
            
            
            maskLayer.backgroundColor = UIColor.blackColor().CGColor
            
            maskLayer.path = path;
            maskLayer.fillRule = kCAFillRuleEvenOdd
            
            // Release the path since it's not covered by ARC.
            maskableView!.layer.mask = maskLayer
            maskableView!.clipsToBounds = true
        }
    }
    
    func updateColor(toColor color: UIColor) {
        innerCircle.backgroundColor = color
    }
}
