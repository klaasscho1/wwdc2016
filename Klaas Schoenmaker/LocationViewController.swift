//
//  LocationViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 24-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit
import MapKit

let ZOOMED_IN_RADIUS: CLLocationDistance = 300
let ZOOMED_OUT_RADIUS: CLLocationDistance = 6000000

class LocationViewController: DetailPageController {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var backgroundShadow: UIView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let initLocation = CLLocation(latitude: 52.653053, longitude: 4.842110)
    let centerLocation = CLLocation(latitude: 42.407235, longitude: -54.843750)
    
    let locations: [String : CLLocation] = [
        "auc" : CLLocation(latitude: 52.355051, longitude: 4.951079),
        "triple" : CLLocation(latitude: 52.625206, longitude: 4.772830),
        "wwdc15" : CLLocation(latitude: 37.783294, longitude: -122.403445),
        "inf-olm" : CLLocation(latitude: 52.090737, longitude: 5.12142),
        "jng-hnd" : CLLocation(latitude: 52.370216, longitude: 4.895168)
    ]
    
    let titles: [String: String] = [
        "auc" : "Amsterdam University College",
        "triple" : "Triple",
        "wwdc15" : "WWDC 2015",
        "inf-olm" : "Dutch Informatics Olympiad",
        "jng-hnd" : "Jonge 100 Nominee"
    ]
    
    var keysForTitles: [(String, String)] = []
    
    let descriptions: [String: String] = [
        "auc" : "Just a few weeks ago I got a letter from AUC that I am admitted to the university as 1 of 300 other students. Amsterdam University College is a Liberal Arts & Sciences university that\'s fully English-spoken and very exclusive. I had to work very hard to get admitted, so you can understand that I\'m very excited to go there.",
        "triple" : "Triple is by far the biggest app development agency in the Netherlands. They develop apps for major media companies like RTL, but also for telecom companies like Vodafone and Ziggo. After last year\'s WWDC I was asked for a cup of coffee at their office, and I\'ve been working at Triple ever since. ",
        "wwdc15" : "Last year I finally made the switch to Swift. After hearing about the WWDC Scholarships I tried my luck and decided to apply for one. A few weeks of excitement later I heard that I won the scholarship. This week in San Francisco has by far been the greatest week in my life, and I hope I can do it over at least once more.",
        "inf-olm" : "Last year, just before the WWDC I participated in the Dutch Informatics Olympiad (or NIO). I didn\'t go there with high expectations, but after a very hard semi-final I came in 9th, which meant that I was admitted to the finals. Unfortunately, the competition was a bit too harsh, so I couldn\'t go to the international finals. Nontheless, it was a great experience that I won\'t forget any time soon.",
        "jng-hnd" : "After releasing my latest app, Ad-Blocker, my co-developer (Wouter) and I received a lot of media attention. Because of this, we were nominated for the Ondertussen.nl Jonge 100, an award for 100 of the most innovative and creative young entrepreneurs in the Netherlands."
    ]
    
    let images: [String: UIImage] = [
        "auc" : UIImage(named: "auc.jpg")!,
        "triple" : UIImage(named: "triple.jpg")!,
        "wwdc15" : UIImage(named: "wwdc.png")!,
        "inf-olm" : UIImage(named: "nio.jpg")!,
        "jng-hnd" : UIImage(named: "jonge100.png")!
    ]
    
    let states: [Int : String?] = [
        0 : nil,
        1 : "inf-olm",
        2 : "triple",
        3 : "jng-hnd",
        4 : "auc",
        5 : "wwdc15"
    ]
    
    var annotations: [String : MKAnnotation] = [:]
    
    var currentState: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.userInteractionEnabled = false
        
        keysForTitles = titles.reverse()
        
        self.zoomInOnLocation(initLocation)
        
        var annotations = [MKAnnotation]()
        
        for (identifier, location) in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = titles[identifier]
            annotation.subtitle = descriptions[identifier]
            self.annotations[identifier] = annotation
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
        
        indexLabel.text = "\(currentState)/\(states.count-1)"
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.5)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: backgroundShadow.frame.size.height)
        
        backgroundShadow.layer.insertSublayer(gradient, atIndex: 0)
        
        initUI()
    }
    
    func initUI() {
        forwardButton.alpha = 0.0
        backButton.alpha = 0.0
        backgroundShadow.alpha = 0.0
        indexLabel.alpha = 0.0
        forwardButton.setTitle("›", forState: .Normal)
    }
    
    func zoomInOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  ZOOMED_IN_RADIUS * 2.0, ZOOMED_IN_RADIUS * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func zoomOut() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate,
                                                                  ZOOMED_OUT_RADIUS * 2.0, ZOOMED_OUT_RADIUS * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func dropAnnotations() {
        
    }
    
    override func forcePressChanged(forceStrength: Float) {
        let max_radius: CLLocationDistance = 600000
        
        let progressRadius = Double(Float(ZOOMED_IN_RADIUS - (ZOOMED_IN_RADIUS - max_radius)) * forceStrength)
        
        let progressRegion = MKCoordinateRegionMakeWithDistance(initLocation.coordinate, progressRadius*2, progressRadius*2)
        
        mapView.setRegion(progressRegion, animated: false)
    }
    
    override func forcePressEnded(forceStrength: Float) {
        zoomInOnLocation(initLocation)
    }
    
    override func forcePressFinalized() {
        zoomOut()
        dropAnnotations()
        
        self.backButton.enabled = false
        
        UIView.animateWithDuration(1.0) { 
            self.forwardButton.alpha = 1.0
            self.backButton.alpha = 0.3
            self.backgroundShadow.alpha = 1.0
            self.indexLabel.alpha = 1.0
        }
    }

    @IBAction func goForward(sender: AnyObject) {
        self.backButton.enabled = true
        self.backButton.alpha = 1.0
        mapView.userInteractionEnabled = true
        
        if let state = states[currentState+1] {
            currentState += 1
            
            let location = locations[state!]
            
            mapView.selectAnnotation(self.annotations[state!]!, animated: true)
            
            zoomInOnLocation(location!)
        } else {
            //close
            currentState = 0
            mapView.deselectAnnotation(annotations["wwdc15"], animated: false)
            zoomInOnLocation(initLocation)
            UIView.animateWithDuration(1.0, animations: {
                self.initUI()
            })
            self.delegate?.detailPageClosed()
        }
        
        indexLabel.text = "\(currentState)/\(states.count-1)"
        
        if currentState == states.count - 1 {
            forwardButton.setTitle("×", forState: .Normal)
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        currentState -= 1
        
        if currentState != 0 {
            let location = locations[states[currentState]!!]
            
            mapView.selectAnnotation(self.annotations[states[currentState]!!]!, animated: true)
            
            zoomInOnLocation(location!)
        } else {
            mapView.deselectAnnotation(self.annotations["inf-olm"], animated: true)
            mapView.userInteractionEnabled = false
            zoomOut()
        }
        
        if let _ = states[currentState-1] {
            
        } else {
            self.backButton.enabled = false
            self.backButton.alpha = 0.3
        }
        
        indexLabel.text = "\(currentState)/\(states.count-1)"
        
        forwardButton.setTitle("›", forState: .Normal)
        
    }
}

extension LocationViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        annotationView.canShowCallout = true
        annotationView.animatesDrop = true
        
        let infoButton = UIButton(type: UIButtonType.InfoLight)
        
        annotationView.rightCalloutAccessoryView = infoButton
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(calloutTapped))
        view.addGestureRecognizer(gesture)
    }
    
    func calloutTapped(sender: UITapGestureRecognizer) {
        let view = sender.view! as! MKAnnotationView
        
        openInfoForView(view)
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        openInfoForView(view)
    }
    
    func openInfoForView(view: MKAnnotationView) {
        var theKey: String!
        
        let anTitle = view.annotation?.title!
        
        for (key, title) in titles {
            if title == anTitle {
                theKey = key
            }
        }
        
        let infoVC = storyboard!.instantiateViewControllerWithIdentifier("information-vc") as! UINavigationController
        
        let vc = infoVC.viewControllers.first as! InformationViewController
        
        vc.titleString = titles[theKey]
        vc.text = descriptions[theKey]
        vc.image = images[theKey]
        
        self.presentViewController(infoVC, animated: true, completion: nil)
    }
}
