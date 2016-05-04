//
//  ThanksViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 28-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {
    @IBOutlet weak var klaasLbl: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var thanksHeader: UILabel!
    @IBOutlet weak var thanksBody: UILabel!
    
    @IBOutlet weak var badgeY: NSLayoutConstraint!
    @IBOutlet weak var badge: UIView!
    
    @IBOutlet weak var cord: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reinit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateIn() {
        UIView.animateWithDuration(3.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: .CurveEaseInOut, animations: {
            self.badgeY.constant = 50
            self.badge.layoutIfNeeded()
            }) { (val) in
                
        }
        
        UIView.animateWithDuration(1.0) { 
            self.thanksHeader.alpha = 1.0
            self.thanksBody.alpha = 1.0
            self.restartButton.alpha = 1.0
        }
        
        UIView.animateWithDuration(2.0, delay: 1.0, options: .CurveEaseInOut, animations: {
            self.klaasLbl.alpha = 1.0
            }) { (val) in
                
        }
    }
    
    func reinit() {
        badgeY.constant = -300
        
        thanksHeader.alpha = 0.0
        thanksBody.alpha = 0.0
        restartButton.alpha = 0.0
        klaasLbl.alpha = 0.0
        
        badge.layoutIfNeeded()
    }
    
    
    @IBAction func restartTheApp(sender: AnyObject) {
        
    }
    
}
