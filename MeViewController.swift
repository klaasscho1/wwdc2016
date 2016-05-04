//
//  MeViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 19-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

import Photos
import PhotosUI

let MAX_FRAME_INDEX: Float = 21

class MeViewController: DetailPageController {
    var photoView: UIImageView!
    var closeButton: UIButton!
    
    @IBOutlet weak var closingButton: UIButton!
    @IBOutlet weak var titleLabe: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        photoView.image = UIImage(named: "me_frame_0.gif")
        photoView.contentMode = UIViewContentMode.ScaleAspectFill
        photoView.center.x = self.view.frame.width/2
        photoView.clipsToBounds = true
        photoView.layer.masksToBounds = true
        
        initUI()
        
        self.view.addSubview(photoView)
    }
    
    func initUI() {
        titleLabe.alpha = 0.0
        titleLabe.center.x = self.view.frame.width/2 - 50
        descLabel.alpha = 0.0
        descLabel.center.x = self.view.frame.width/2 - 50
        
        closingButton.alpha = 0.0
    }
    
    override func forcePressStarted(forceStrength: Float) {
        photoView.image = UIImage(named: "me_frame_0.gif")
    }
    
    override func forcePressChanged(forceStrength: Float) {
        UIView.transitionWithView(self.photoView, duration: 1.0, options: .TransitionCrossDissolve, animations: {
            
            self.photoView.image = UIImage(named: "me_frame_\(Int(MAX_FRAME_INDEX * forceStrength)).gif")
            
            }, completion: nil)
    }
    
    override func forcePressEnded(forceStrength: Float) {
        photoView.image = UIImage(named: "me_frame_0.gif")
    }
    
    override func forcePressFinalized() {
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.photoView.center = CGPointMake(self.view.frame.width/2, 230)
            self.photoView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.closingButton.alpha = 1.0
            
            }, completion: { (value) in
                
        })
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseOut, animations: {
            self.titleLabe.alpha = 1.0
            self.titleLabe.center.x = self.view.frame.width/2
            }, completion: nil)
        
        UIView.animateWithDuration(1.0, delay: 1.5, options: .CurveEaseOut, animations: {
            self.descLabel.alpha = 1.0
            self.descLabel.center.x = self.view.frame.width/2
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
            self.photoView.frame.size.height = self.photoView.frame.size.width
            
            }, completion: nil)
        
        let radiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
        radiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        radiusAnimation.fromValue = 0
        radiusAnimation.toValue = self.photoView.frame.width
        radiusAnimation.duration = 0.5
        
        self.photoView.layer.addAnimation(radiusAnimation, forKey: "cornerRadius")
        self.photoView.layer.cornerRadius = self.photoView.frame.width
        
        UIView.transitionWithView(self.photoView, duration: 1.0, options: .TransitionCrossDissolve, animations: {
            
            self.photoView.image = UIImage(named: "me.png")
            
            }, completion: { (val) in
                
        })
        
    }
    
    @IBAction func close(sender: AnyObject) {
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.initUI()
            }) { (val) in
                self.delegate?.detailPageClosed()
        }
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.photoView.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.closingButton.alpha = 1.0
            
            }, completion: { (value) in
                
        })
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            self.photoView.frame.origin = CGPointZero
            self.photoView.frame.size.height = self.view.frame.size.height
            
            }, completion: { val in
                
                UIView.transitionWithView(self.photoView, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                    
                    self.photoView.image = UIImage(named: "me_frame_0.gif")
                    
                    }, completion: { (val) in
                        
                })
                let radiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
                radiusAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                radiusAnimation.fromValue = self.photoView.layer.cornerRadius
                radiusAnimation.toValue = 0
                radiusAnimation.duration = 0.5
                
                self.photoView.layer.addAnimation(radiusAnimation, forKey: "cornerRadius")
                self.photoView.layer.cornerRadius = 0
        })
    }
}
