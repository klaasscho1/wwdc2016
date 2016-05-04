//
//  MediaViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 26-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class MediaViewController: DetailPageController {
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    typealias Program = (title: String, viewers: Int, date: String, description: String, fileName: String)
    
    let min_scale: Float = 0.005
    var whiteLayer: UIView!
    var liveView: PHLivePhotoView!
    var titleLabel: UILabel!
    var viewerLabel: UILabel!
    var descriptionLabel: UILabel!
    
    @IBOutlet weak var liveContainer: UIView!
    
    var programs: [Program] = [
        (
            title: "De Wereld Draait Door",
            viewers: 1238000,
            date: "16th september 2015",
            description: "De Wereld Draait Door is one of the biggest talkshows in the Netherlands. Wouter Stierhout and I were invited there to talk about the launch of our latest app, Ad-Blocker. We talked mainly about the controversy surrounding adblockers and the impact they have on the news websites.",
            fileName: "dwdd"
        ),
        (
            title: "Van Liempt Live",
            viewers: 4000,
            date: "9th september 2015",
            description: "Van Liempt Live was the first television program that Wouter and I appeared in. Van Liempt Live is basically a small talkshow on a business channel in the Netherlands. The program itself isn't too big, but it did allow us to appear in bigger ones like De Wereld Draait Door",
            fileName: "vanliempt"
        ),
        (
            title: "NOS Journaal",
            viewers: 2409000,
            date: "10th september 2015",
            description: "The NOS Journaal is the biggest news broadcasting program in the Netherlands. Wouter and I were approached by these guys because of our performance at Van Liempt Live. The program is one of the most widely watched programmes in the Netherlands, so of course it did us good.",
            fileName: "nos"
        )
    ]
    
    var currentProgramIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveView = PHLivePhotoView(frame: CGRectMake(0,0,self.view.frame.width,200))
        
        let program = programs.first!
        
        let photo = NSBundle.mainBundle().URLForResource(program.fileName, withExtension: "JPG")
        let video = NSBundle.mainBundle().URLForResource(program.fileName, withExtension: "mov")
        
        PHLivePhoto.requestLivePhotoWithResourceFileURLs([photo!, video!], placeholderImage: UIImage(named: photo!.absoluteString), targetSize: liveView.frame.size, contentMode: PHImageContentMode.AspectFill) { (livePhoto, obj) in
            self.liveView.livePhoto = livePhoto
        }
        
        self.view.addSubview(liveView)
        
        self.view.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        let livePhotoIcon = LiveIconView(frame: CGRectMake(10, 10, 30, 30))
        livePhotoIcon.animateConstantly()
        
        let liveBack = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        liveBack.frame = CGRectMake(0,0,40,40)
        liveBack.center = livePhotoIcon.center
        liveBack.layer.cornerRadius = liveBack.frame.width/2
        liveBack.layer.masksToBounds = true

        self.view.addSubview(liveBack)
        self.view.addSubview(livePhotoIcon)
        
        whiteLayer = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        whiteLayer.backgroundColor = UIColor.whiteColor()
        whiteLayer.alpha = 1.0
        self.view.addSubview(whiteLayer)
        self.view.bringSubviewToFront(whiteLayer)
        
        self.titleLabel = UILabel(frame: CGRectMake(15, self.liveView.frame.height+10,self.liveView.frame.width-30, 30))
        titleLabel.text = program.title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(25.0)
        titleLabel.sizeToFit()
        
        self.view.addSubview(titleLabel)
        
        self.viewerLabel = UILabel(frame: CGRectMake(15, self.titleLabel.frame.origin.y+self.titleLabel.frame.height,self.titleLabel.frame.width,20))
        viewerLabel.text = "\(program.viewers) viewers - \(program.date)"
        viewerLabel.textColor = UIColor.whiteColor()
        viewerLabel.font = UIFont.systemFontOfSize(12)
        viewerLabel.alpha = 0.5
        viewerLabel.sizeToFit()
        
        self.view.addSubview(viewerLabel)
        
        let separatorLine = UIView(frame: CGRectMake(15, viewerLabel.frame.origin.y + viewerLabel.frame.height + 10, UIScreen.mainScreen().bounds.width - 15, 0.5))
        separatorLine.backgroundColor = UIColor.lightGrayColor()
        separatorLine.alpha = 0.5
        
        self.view.addSubview(separatorLine)
        
        self.descriptionLabel = UILabel(frame: CGRectMake(15, separatorLine.frame.origin.y + separatorLine.frame.height + 10, UIScreen.mainScreen().bounds.width - 30, UIScreen.mainScreen().bounds.height - separatorLine.frame.origin.y))
        descriptionLabel.text = program.description
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.font = UIFont.systemFontOfSize(15)
        descriptionLabel.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let attributedString = NSAttributedString(string: descriptionLabel.text!, attributes: [
                                                    NSParagraphStyleAttributeName: paragraphStyle,
                                                    NSBaselineOffsetAttributeName: NSNumber(float: 0)])
        
        descriptionLabel.attributedText = attributedString
        
        descriptionLabel.sizeToFit()
        
        self.view.addSubview(descriptionLabel)
        
        self.view.bringSubviewToFront(coverView)
    }
    
    func prepareUI() {
        coverView.alpha = 1.0
    }
    
    override func forcePressStarted(forceStrength: Float) {
        prepareUI()
    }
    
    override func forcePressChanged(forceStrength: Float) {
        //self.view.alpha = 0.3 + CGFloat(0.7 * forceStrength)
        if forceStrength <= 0.5 {
            let progress = forceStrength / 0.5
            
            let xProg: CGFloat = CGFloat(1.5 * progress)
            let yProg: CGFloat = CGFloat(min_scale * progress)
            
            self.view.transform = CGAffineTransformMakeScale(xProg, yProg)
        } else {
            let progress = forceStrength - 0.5
            
            coverView.alpha = 1 - CGFloat(progress)
            
            let xScl = 1.5 - (0.5 * progress)
            let yScl = min_scale + (1.0 - min_scale) * progress
            
            self.view.transform = CGAffineTransformMakeScale(CGFloat(xScl), CGFloat(yScl))
        }
    }
    
    override func forcePressEnded(forceStrength: Float) {
        UIView.animateWithDuration(0.5, animations: {
            self.view.transform = CGAffineTransformMakeScale(0.0, 0.0)
            }) { (val) in
                self.prepareUI()
        }
    }
    
    override func forcePressFinalized() {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
        
        UIView.animateWithDuration(1.0) {
            self.coverView.alpha = 0.0
        }
    }
    
    func setCurrentProgram(program: Program) {
        let photo = NSBundle.mainBundle().URLForResource(program.fileName, withExtension: "JPG")
        let video = NSBundle.mainBundle().URLForResource(program.fileName, withExtension: "mov")
        
        PHLivePhoto.requestLivePhotoWithResourceFileURLs([photo!, video!], placeholderImage: UIImage(named: photo!.absoluteString), targetSize: liveView.frame.size, contentMode: PHImageContentMode.AspectFill) { (livePhoto, obj) in
            self.liveView.livePhoto = livePhoto
        }
        
        titleLabel.text = program.title
        titleLabel.sizeToFit()
        viewerLabel.text = "\(program.viewers) viewers - \(program.date)"
        viewerLabel.sizeToFit()
        descriptionLabel.text = program.description
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let attributedString = NSAttributedString(string: descriptionLabel.text!, attributes: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSBaselineOffsetAttributeName: NSNumber(float: 0)])
        
        descriptionLabel.attributedText = attributedString
    }
    
    @IBAction func next(sender: AnyObject) {
        currentProgramIndex += 1
        
        if currentProgramIndex == programs.count - 1 {
            nextButton.enabled = false
        }
        
        previousButton.enabled = true
        
        setCurrentProgram(programs[currentProgramIndex])
    }
    
    @IBAction func previous(sender: AnyObject) {
        currentProgramIndex -= 1
        
        if currentProgramIndex == 0 {
            previousButton.enabled = false
        }
        
        nextButton.enabled = true
        
        setCurrentProgram(programs[currentProgramIndex])
    }
    
    @IBAction func close(sender: AnyObject) {
        
        UIView.animateWithDuration(0.2, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.5, CGFloat(self.min_scale))
            }) { (val) in
                self.delegate?.detailPageClosed()
                UIView.animateWithDuration(0.5, animations: {
                    self.view.transform = CGAffineTransformMakeScale(0.0, 0.0)
                    })
        }
    }
    
}
