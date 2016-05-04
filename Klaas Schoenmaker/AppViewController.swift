//
//  AppViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 23-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

let MAX_ALPHA_IN_TRANSITION: CGFloat = 0.8
let MAX_SCALE_IN_TRANSITION: CGFloat = 0.3
let MAX_ICON_SCALE: CGFloat = 1.5

class AppViewController: DetailPageController {
    var appLayer: UIView!
    
    let appInformation: [String : (icon: UIImage, image: UIImage, text: String)] = [
        "Ad-Blocker" : (
            icon: UIImage(named: "AdBlocker-Icon")!,
            image: UIImage(named: "adblocker.jpeg")!,
            text: "At last year\'s WWDC, Wouter Stierhout and I saw a talk about the new Safari Content Blocking. Right after the talk we looked at each other and we said \'we should make an adblocker with this\'. And so we did.\n\nWe spent our whole summer vacation working on the app, and after right before the launch of iOS 9, we were ready. The launch of our app paired with a lot of rumour in the Dutch media. We were discussed in television programs like De Wereld Draait Door (the biggest Dutch talkshow), the NOS Journaal (the biggest Dutch news broadcaster) and various other media."
        ),
        "Weten" : (
            icon: UIImage(named: "Weten-Icon")!,
            image: UIImage(named: "weten.png")!,
            text: "Weten is one of my latest apps, and probably the one I\'ve been working on the longest. The main purpose of the app is allowing people with certain food allergies to visit a restaurant\'s page and see if they can eat certain dishes.\n\nI\'ve developed everything for the app, from the app itself to the UI design, to the website (wetenapp.nl), to the backend which was quite a complex job all together. The app is planned to launch this fall."
        ),
        "Draw my Life" : (
            icon: UIImage(named: "DML-Icon")!,
            image: UIImage(named: "dml.png")!,
            text: "Draw my Life is an app I made for Applits, a small app developing company in America. The app is pretty simple, but at the time, developing the app was quite a challenge for me.\n\nAll the app really does is allowing the user to draw a few frames with the drawing tools provided, and then allowing the user to narrate over them with the microphone in their device. The app currently has a few thousand downloads for the paid version and several more for the free (\'lite\') version."
        ),
        "Guestbook" : (
            icon: UIImage(named: "Guestbook-Icon")!,
            image: UIImage(named: "guestbook.png")!,
            text: "Last year, just after WWDC 2015, I started working at Triple IT, one of the biggest app development agencies in the Netherlands. The first app I made for them was an internally used one, Guestbook. The idea is fairly simple; People that visit the office can take a photo of themselves taking on a funny pose. Nontheless, the app uses some pretty complex UI elements, like an automatically, infinitely scrolling collectionview with two sides that go opposite ways and different speeds.\n\nI know, it\'s quite a mouthful."
        ),
        "Dag vd Bouw" : (
            icon: UIImage(named: "DVDB-Icon")!,
            image: UIImage(named: "dvdb.jpg")!,
            text: "Dag van de Bouw is an app I developed for Bouwmensen. \"Dag van de Bouw\" is a day especially for high school students that allows them to visit certain building sites and ask questions to the people working on the construction.\n\nThe main goal of the app is to let the students take pictures of buildings and create a collage with these images. There was also a price bound to this contest, so the student with the best collage could win an iPad."
        ),
        "Trinitas" : (
            icon: UIImage(named: "Trinitas-Icon")!,
            image: UIImage(named: "trinitas.png")!,
            text: "The Trinitas College app was one of the first apps I\'ve ever worked on. The app is meant for students of the Trinitas College, my school. \n\nThe functionality is pretty basic, but it allows the students to see their current timetables and their latest grades. The first version of the app existed mainly of a WebView with the school\'s site, which wasn\'t received too well. The second version was fully native though and used some cool UI elements developed specifically for this app. I still sometimes see people walking around with this app on their iPhone\'s, something that really motivates me to work on other apps since I see that they really help other people."
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        appLayer = UIView(frame: CGRectMake(0,0,self.view.frame.width, self.view.frame.height))
        
        for (index, (name, information)) in appInformation.enumerate() {
            print("Index: \(index)")
            let row = 1 + Int(index / 4)
            let column = index % 4 + 1
            let appView = AppIconView(inRow: row, inColumn: column, withIcon: information.icon, andName: name)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(appIconTapped))
            appView.addGestureRecognizer(gesture)
            
            appLayer.addSubview(appView)
        }
        
        let backButton = AppIconView(inRow: -1, inColumn: -1, withIcon: UIImage(named: "Home")!, andName: "Back")
        backButton.index = -1
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(appIconTapped))
        backButton.addGestureRecognizer(gesture)
        
        appLayer.addSubview(backButton)
        
        initUI()
        
        self.view.addSubview(appLayer)
        
        // Do any additional setup after loading the view.
    }
    
    func appIconTapped(sender: UITapGestureRecognizer) {
        let icon = sender.view! as! AppIconView
        
        if icon.name == "Back" {
            closeUI()
        } else {
            let name = icon.name
            
            let information = appInformation[name]
            
            let infoVC = storyboard!.instantiateViewControllerWithIdentifier("information-vc") as! UINavigationController
            
            let vc = infoVC.viewControllers.first as! InformationViewController
            
            vc.titleString = name
            vc.image = information?.image
            vc.text = information?.text
            
            self.presentViewController(infoVC, animated: true, completion: nil)
        }
    }
    
    func initUI() {
        appLayer.alpha = 0.0
        appLayer.transform = CGAffineTransformMakeScale(MAX_ICON_SCALE, MAX_ICON_SCALE)
    }
    
    override func forcePressChanged(forceStrength: Float) {
        let forceStrength = CGFloat(forceStrength)
        appLayer.alpha = forceStrength * MAX_ALPHA_IN_TRANSITION
        
        let scale = MAX_ICON_SCALE - forceStrength * MAX_SCALE_IN_TRANSITION
        
        print(scale)
        
        appLayer.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    override func forcePressFinalized() {
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5, options: .CurveEaseOut, animations: {
            self.appLayer.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.appLayer.alpha = 1.0
            }) { (val) in
                
        }
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func forcePressEnded(forceStrength: Float) {
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.initUI()
        }) { (val) in
        }
    }
    
    func closeUI() {
        self.delegate?.detailPageClosed()
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.initUI()
            }) { (val) in
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
}
