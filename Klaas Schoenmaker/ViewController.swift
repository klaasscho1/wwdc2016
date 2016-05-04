//
//  ViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 19-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit
import AudioToolbox
import MapKit

final class ViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    var dotView: WWDCDotView!
    var initRaster: WWDCDotRaster!
    var pageView: UIPageViewController!
    var touchView: PulsingTouchView!
    var currentIndex = 0
    var shouldFeelTouches = true
    var oldHeight: CGFloat!
    var wentToThanks = false
    
    @IBOutlet weak var shadowView: UIView!
    var currentContainedView: DetailPageController!
    var doParallex = true

    var updateTouches = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CLLocationManager().requestAlwaysAuthorization()
        
        oldHeight = pageView.view.frame.height
        pageView.view.frame.size.height = oldHeight
        
        pageView.delegate = self
        
        let raster: WWDCDotRaster = PageData.rasters().first!
        let width = self.view.frame.width-20
        let height = self.view.frame.height-30
        
        var controller = storyboard!.instantiateViewControllerWithIdentifier(PageData.viewControllerIdentifiers().first!) as! DetailPageController
        
        prepareViewControllerForBackground(&controller)
        
        currentContainedView = controller
        
        
        let dotView = WWDCDotView(frame: CGRectMake(10, 40, width, height), dotRaster: raster)
        
        dotView.clipsToBounds = false
        
        let touchView = PulsingTouchView(frame: CGRectMake(0,0,0,0))
        
        touchView.center.x = view.frame.width/2
        touchView.center.y = view.frame.height - 100
        
        touchView.userInteractionEnabled = false
        touchView.maskableView = shadowView
        
        view.addSubview(touchView)
        view.bringSubviewToFront(touchView)
        
        self.dotView = dotView
        self.touchView = touchView
        self.initRaster = raster
        
        let welcomeVC = storyboard!.instantiateViewControllerWithIdentifier("welcome-vc")
        
        self.presentViewController(welcomeVC, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pageview_embed" {
            self.pageView = segue.destinationViewController as! UIPageViewController
            self.pageView.dataSource = self
            self.pageView.setViewControllers([createCategoryViewController(0)!], direction: .Forward, animated: false, completion: nil)
            
        }
    }
    
    func prepareViewControllerForBackground(inout controller: DetailPageController) {
        controller.willMoveToParentViewController(self)
        self.view.addSubview(controller.view)
        self.view.sendSubviewToBack(controller.view)
        self.addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        controller.delegate = self
        
        if controller is MediaViewController {
            doParallex = false
        } else {
            doParallex = true
        }
        
        if doParallex {
            addParallaxToView(controller.view)
            controller.view.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }
    }
    
    func setCurrentDetailPageController(controller: DetailPageController) {
        var controller = controller
        let oldContainedView = self.currentContainedView
        UIView.animateWithDuration(0.5, animations: {
            self.currentContainedView.view.alpha = 0.0
            }) { (val) in
                oldContainedView.willMoveToParentViewController(nil)
                oldContainedView.view.removeFromSuperview()
                oldContainedView.removeFromParentViewController()
        }
        
        prepareViewControllerForBackground(&controller)
        
        self.currentContainedView = controller
        
        UIView.animateWithDuration(0.5, animations: {
            controller.view.alpha = 1.0
            }, completion: { (val) in
        })
    }
}

extension ViewController {
    func isParallexVC(viewController: UIViewController) -> Bool {
        if viewController is MediaViewController {
            return false
        }
        
        return true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldFeelTouches {
            if let touch = touches.first where traitCollection.forceTouchCapability == .Available {
                if updateTouches {
                    let progress = touch.force / touch.maximumPossibleForce
                    
                    touchView.setTouchForce(progress)
                    
                    currentContainedView.forcePressChanged(Float(progress))
                    
                    let scale = 1.0 + (0.05 - 0.05 * progress)
                    
                    if doParallex {
                        currentContainedView.view.transform = CGAffineTransformMakeScale(scale, scale)
                    }
                    
                    let newDotRaster: WWDCDotRaster = initRaster.map({ (dotRow) -> [Float] in
                        return dotRow.map({ (dot) -> Float in
                            return Float(progress*10.0) * dot
                        })
                    })
                    
                    dotView.updateDotRaster(newDotRaster, animated: false, completion: nil)
                    
                    if progress >= 1.0 {
                        updateTouches = false
                        
                        currentContainedView.view.motionEffects = []
                        
                        hideUI()
                        
                        currentContainedView.forcePressFinalized()
                        
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        if shouldFeelTouches {
            let viewController: CategoryViewController = self.pageView.viewControllers!.last! as! CategoryViewController
            
            initRaster = viewController.dotRaster
            currentIndex = viewController.index
            
            currentContainedView.forcePressStarted(0.0)
            if doParallex {
                currentContainedView.view.transform = CGAffineTransformMakeScale(1.05, 1.05)
            }
            
            UIView.animateWithDuration(0.5) {
                self.pageView.view.alpha = 0
            }
            
            touchView.stopAnimation()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldFeelTouches {
            touchView.resumeAnimation()
            
            currentContainedView.forcePressEnded(0.0)
            UIView.animateWithDuration(0.5) {
                self.pageView.view.alpha = 1.0
            }
            
            if let _ = touches.first where traitCollection.forceTouchCapability == .Available {
                if updateTouches {
                    let newDotRaster: WWDCDotRaster = initRaster.map({ (dotRow) -> [Float] in
                        return dotRow.map({ (dot) -> Float in
                            return 0
                        })
                    })
                    
                    dotView.updateDotRaster(newDotRaster, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if shouldFeelTouches {
            
        }
    }
    
    func hideUI() {
        touchView.hidden = true
        pageView.view.hidden = true
        shouldFeelTouches = false
        shadowView.hidden = true
        containerView.hidden = true
        UIView.animateWithDuration(1.0) { 
            self.shadowView.alpha = 0.0
            self.touchView.alpha = 0.0
            self.shadowView.layer.mask = nil
        }
    }
    
    func showUI() {
        touchView.hidden = false
        pageView.view.hidden = false
        shadowView.hidden = false
        containerView.hidden = false
        shouldFeelTouches = true
        UIView.animateWithDuration(1.0) { 
            self.pageView.view.alpha = 1.0
            self.touchView.alpha = 1.0
            self.shadowView.alpha = 0.3
        }
        shouldFeelTouches = true
        touchView.shouldMeasureForce = true
        touchView.resumeAnimation()
        updateTouches = true
    }
    
    func addParallaxToView(vw: UIView) {
        let amount = 20
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}


extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        print("Added before")
        
        if let viewController = viewController as? CategoryViewController {
            var index = viewController.index
            guard index != NSNotFound && index != 0 else { return nil }
            index = index - 1
            return createCategoryViewController(index)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        print("Added after")
        if let viewController = viewController as? CategoryViewController {
            var index = viewController.index
            guard index != NSNotFound else { return nil }
            index = index + 1
            guard index != PageData.titles().count else {
                return storyboard?.instantiateViewControllerWithIdentifier("thanks-vc")
            }
            return createCategoryViewController(index)
        }
        return nil
    }
    
    func createCategoryViewController(index: Int) -> CategoryViewController? {
        let page = storyboard!.instantiateViewControllerWithIdentifier("CategoryViewController")
                as! CategoryViewController
        
        page.titleString = PageData.titles()[index]
        page.descriptionString = PageData.descriptions()[index]
        page.index = index
        page.dotRaster = PageData.rasters()[index]
            
        return page
        
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return PageData.titles().count + 1
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        
        let viewController = self.pageView.viewControllers!.last!
        
        if let vc = viewController as? CategoryViewController {
            if wentToThanks {
                wentToThanks = false
                UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
                    self.pageView.view.frame.size.height = self.oldHeight
                    self.touchView.alpha = 1.0
                    }, completion: { (val) in
                        
                })
            }
            
            let index = vc.index
            
            
            
            let embedView = storyboard!.instantiateViewControllerWithIdentifier(PageData.viewControllerIdentifiers()[index])
            
            setCurrentDetailPageController(embedView as! DetailPageController)
        } else {
            wentToThanks = true
            UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.pageView.view.frame.size.height = self.view.frame.height + 40
                self.touchView.alpha = 0.0
                }, completion: { (val) in
                    let vc = viewController as! ThanksViewController
                    vc.animateIn()
            })
            for view in pageView.view.subviews {
                if view is UIScrollView {
                    let v = view as! UIScrollView
                    v.scrollEnabled = false
                }
            }
        }
    }
}

extension ViewController: DetailPageDelegate {
    func detailPageClosed() {
        showUI()
        addParallaxToView(currentContainedView.view)
        if doParallex {
            UIView.animateWithDuration(1.0) {
                self.currentContainedView.view.transform = CGAffineTransformMakeScale(1.05, 1.05)
            }
        }
        print("Detail page closed")
    }
}

