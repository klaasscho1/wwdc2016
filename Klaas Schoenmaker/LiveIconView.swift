import UIKit

internal class DottedCircle: UIView {
    var dotSize: CGSize
    var color: UIColor
    
    var noOfDotPairs: CGFloat = 19
    
    var dotPairs = [UIView]()
    
    init(frame: CGRect, dotSize: CGSize, color: UIColor) {
        self.dotSize = dotSize
        self.color = color
        
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let rotationMultiplier = CGFloat(M_PI) / noOfDotPairs
        for dotPairNo in 0..<Int(noOfDotPairs) {
            let dotPair = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
            
            let dot1 = UIView(frame: CGRectMake(0, 0, dotSize.width, dotSize.height))
            dot1.center.x = dotPair.frame.width/2
            dot1.layer.cornerRadius = dotSize.height/2
            dot1.backgroundColor = self.color
            
            let dot2 = UIView(frame: CGRectMake(0, dotPair.frame.height - dotSize.height, dotSize.width, dotSize.height))
            dot2.center.x = dotPair.frame.width/2
            dot2.layer.cornerRadius = dotSize.height/2
            dot2.backgroundColor = self.color
            
            dotPair.addSubview(dot1)
            dotPair.addSubview(dot2)
            
            dotPair.transform = CGAffineTransformMakeRotation(rotationMultiplier*CGFloat(dotPairNo))
            
            self.addSubview(dotPair)
        }
    }
}

class LiveIconView: UIView {
    
    var firstInnerRing: UIView!
    var secondInnerRing: UIView!
    
    var firstOuterRing: UIView!
    var secondOuterRing: UIView!
    
    var firstDotRing: UIView!
    var secondDotRing: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setup() {
        let color = UIColor.whiteColor()//UIColor(red:0.98, green:0.78, blue:0.18, alpha:1.0)
        let center = CGPointMake(self.frame.width/2, self.frame.height/2)
        
        let innerRingSize = self.frame.width/3
        let innerRingFrame = CGRectMake(0, 0, innerRingSize, innerRingSize)
        
        self.firstInnerRing = UIView(frame: innerRingFrame)
        firstInnerRing.center = center
        firstInnerRing.backgroundColor = UIColor.clearColor()
        firstInnerRing.layer.borderColor = color.CGColor
        firstInnerRing.layer.borderWidth = innerRingSize/4
        firstInnerRing.layer.cornerRadius = innerRingSize/2
        
        firstInnerRing.layer.shadowColor = UIColor.blackColor().CGColor
        firstInnerRing.layer.shadowOffset = CGSizeMake(0, 0)
        firstInnerRing.layer.shadowRadius = 10
        firstInnerRing.layer.shadowOpacity = 0.0
        
        self.secondInnerRing = UIView(frame: innerRingFrame)
        secondInnerRing.center = center
        secondInnerRing.backgroundColor = UIColor.clearColor()
        secondInnerRing.layer.borderColor = color.CGColor
        secondInnerRing.layer.borderWidth = innerRingSize/4
        secondInnerRing.layer.cornerRadius = innerRingSize/2
        secondInnerRing.alpha = 0.0
        
        let outerRingSize = self.frame.width * (2/3)
        let outerRingFrame = CGRectMake(0, 0, outerRingSize, outerRingSize)
        
        self.firstOuterRing = UIView(frame: outerRingFrame)
        firstOuterRing.center = center
        firstOuterRing.backgroundColor = UIColor.clearColor()
        firstOuterRing.layer.borderColor = color.CGColor
        firstOuterRing.layer.borderWidth = outerRingSize/20
        firstOuterRing.layer.cornerRadius = outerRingSize/2
        
        firstOuterRing.layer.shadowColor = UIColor.blackColor().CGColor
        firstOuterRing.layer.shadowOffset = CGSizeMake(0, 0)
        firstOuterRing.layer.shadowRadius = 10
        firstOuterRing.layer.shadowOpacity = 0.0
        
        self.secondOuterRing = UIView(frame: outerRingFrame)
        secondOuterRing.center = center
        secondOuterRing.backgroundColor = UIColor.clearColor()
        secondOuterRing.layer.borderColor = color.CGColor
        secondOuterRing.layer.borderWidth = outerRingSize/20
        secondOuterRing.layer.cornerRadius = outerRingSize/2
        secondOuterRing.alpha = 0.0
        
        let dotRingSize = self.frame.width
        let dotRingFrame = CGRectMake(0, 0, dotRingSize, dotRingSize)
        
        let dotSize = CGSizeMake(firstOuterRing.layer.borderWidth, firstOuterRing.layer.borderWidth)
        
        self.firstDotRing = DottedCircle(frame: dotRingFrame, dotSize: dotSize, color: color)
        firstDotRing.center = center
        
        firstDotRing.layer.shadowColor = UIColor.blackColor().CGColor
        firstDotRing.layer.shadowOffset = CGSizeMake(0, 0)
        firstDotRing.layer.shadowRadius = 10
        firstDotRing.layer.shadowOpacity = 0.0
        
        self.secondDotRing = DottedCircle(frame: dotRingFrame, dotSize: dotSize, color: color)
        secondDotRing.center = center
        
        self.addSubview(firstInnerRing)
        self.addSubview(firstOuterRing)
        self.addSubview(secondInnerRing)
        self.addSubview(secondOuterRing)
        self.addSubview(firstDotRing)
        self.addSubview(secondDotRing)
    }
    
    func animate(completion: (() -> Void)?) {
        secondInnerRing.transform = CGAffineTransformMakeScale(0.1, 0.1)
        secondInnerRing.alpha = 0.0
        
        UIView.animateWithDuration(0.5) {
            self.secondInnerRing.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.secondInnerRing.alpha = 1.0
        }
        
        UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.firstInnerRing.transform = CGAffineTransformMakeScale(3.0, 3.0)
            self.firstInnerRing.alpha = 0.0
            self.secondOuterRing.alpha = 1.0
        }) { (val) in
            
        }
        
        UIView.animateWithDuration(2.0, delay: 0.4, options: .CurveEaseInOut, animations: {
            self.firstOuterRing.transform = CGAffineTransformMakeScale(2.0, 2.0)
            self.firstOuterRing.alpha = 0.0
            self.secondDotRing.alpha = 1.0
        }) { (val) in
            
        }
        
        UIView.animateWithDuration(2.0, delay: 0.8, options: .CurveEaseInOut, animations: {
            self.firstDotRing.transform = CGAffineTransformMakeScale(1.8, 1.8)
            self.firstDotRing.alpha = 0.0
        }) { (val) in
            self.firstDotRing.alpha = 1.0
            self.firstDotRing.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.secondDotRing.alpha = 0.0
            
            self.firstInnerRing.alpha = 1.0
            self.firstInnerRing.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.secondInnerRing.alpha = 0.0
            
            self.firstOuterRing.alpha = 1.0
            self.firstOuterRing.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.secondOuterRing.alpha = 0.0
            
            completion?()
        }
    }
    
    func animateConstantly() {
        self.animate { 
            self.animateConstantly()
        }
    }
}