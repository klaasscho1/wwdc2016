//
//  WWDCDotView.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 19-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//


import UIKit

typealias WWDCDotRaster = [[Float]]

// CONSTANTS

let MINIMUM_SCALE: CGFloat = 0.0
let DEFAULT_SPACING: CGFloat = 8

class WWDCDotView: UIView {
    
    private var dotRaster: WWDCDotRaster!
    
    var dotViews: [[UIView]] = []
    var dotSize: CGFloat!
    var dotSpacing: CGFloat!
    
    init(location: CGPoint, dotRaster: WWDCDotRaster, dotSize: CGFloat, dotSpacing: CGFloat) {
        let height = dotSize*CGFloat(dotRaster[0].count) + dotSpacing*(CGFloat(dotRaster[0].count)-1)
        let width = dotSize*CGFloat(dotRaster.count) + dotSpacing*(CGFloat(dotRaster.count)-1)
        
        let frame = CGRectMake(location.x, location.y, height, width)
        
        super.init(frame: frame)
        
        self.dotRaster = dotRaster
        self.dotSize = dotSize
        self.dotSpacing = dotSpacing
        
        self.initDotRaster(dotRaster)
        
        //self.updateDotRaster(dotRaster, animated: false)
    }
    
    init(frame: CGRect, dotRaster: WWDCDotRaster) {
        let noOfDots = dotRaster.first!.count
        
        let dotSize = (frame.width - CGFloat(noOfDots - 1)*DEFAULT_SPACING)/CGFloat(noOfDots)
        
        super.init(frame: frame)
        
        self.dotRaster = dotRaster
        self.dotSize = dotSize
        self.dotSpacing = DEFAULT_SPACING
        
        self.initDotRaster(dotRaster)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initDotRaster(dotRaster: WWDCDotRaster) {
        var currentRow: CGFloat = 0
        var currentViewInRow: CGFloat = 0
        
        for dotRow in dotRaster {
            currentViewInRow = 0
            dotViews.append([])
            
            for dotValue in dotRow {
                let dotView = UIView(frame: CGRectMake(currentViewInRow*(self.dotSize+self.dotSpacing), currentRow*(self.dotSize+self.dotSpacing), self.dotSize, self.dotSize))
                
                let scale = MINIMUM_SCALE + (1 - MINIMUM_SCALE) * CGFloat(dotValue)
                
                dotView.layer.cornerRadius = self.dotSize/2
                dotView.transform = CGAffineTransformMakeScale(scale, scale)
                dotView.backgroundColor = UIColor.whiteColor()
                
                self.addSubview(dotView)
                
                dotViews[Int(currentRow)].append(dotView)
                
                currentViewInRow++
            }
            
            currentRow++
        }
    }
    
    func updateDotRaster(dotRaster: WWDCDotRaster, animated: Bool, completion: ((Bool) -> Void)?) {
        if (dotRaster.count == self.dotRaster.count && dotRaster[0].count == self.dotRaster[0].count) {
            self.dotRaster = dotRaster
            
            var currentRow = 0
            var currentViewInRow = 0
            
            // Possibly animate all dots to their new form
            
            for dotViewRow in dotViews {
                currentViewInRow = 0
                
                for dotView in dotViewRow {
                    let dotValue = dotRaster[currentRow][currentViewInRow]
                    let scale = MINIMUM_SCALE + (1 - MINIMUM_SCALE) * CGFloat(dotValue)
                    
                    if animated {
                        
                        UIView.animateWithDuration(0.3, animations: {
                            dotView.transform = CGAffineTransformMakeScale(scale, scale)
                        })
                        
                    } else {
                        dotView.transform = CGAffineTransformMakeScale(scale, scale)
                    }
                    
                    currentViewInRow += 1;
                }
                
                currentRow += 1
            }
            
            // If animated, wait until all dots are animated before completion is called
            
            if animated {
                let delay = 0.3 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue()) {
                    if let complete = completion {
                        complete(true)
                    }
                }
            } else {
                if let complete = completion {
                    complete(true)
                }
            }
        } else {
            print("Can't update dot raster: Please make sure there are exactly the same amount of dots in the new raster as in the old one.")
            if let complete = completion {
                complete(false)
            }
        }
    }
    
    func updateDotColor(toColor color: UIColor) {
        let _ = dotViews.map { (viewRow) -> [UIView] in
            return viewRow.map({ (view) -> UIView in
                view.backgroundColor = color
                return view
            })
        }
    }
}