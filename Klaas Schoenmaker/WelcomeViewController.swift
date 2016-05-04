//
//  WelcomeViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 30-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit
import AudioUnit
import CoreAudio
import AVFoundation
import CoreAudioKit

typealias Command = (String, String?)

enum WaitingTime {
    case Short
    case Long
}

let newLine: Command = ("showln", "")
let showDot: Command = ("show-dot", nil)

func show(message: String) -> Command {
    return ("show", message)
}

func showln(message: String) -> Command {
    return ("showln", message)
}

func type(message: String) -> Command {
    return ("type", message)
}

func wait(time: WaitingTime) -> Command {
    switch(time) {
    case .Short:
        return ("wait-short", nil)
    case .Long:
        return ("wait-long", nil)
    }
}

let wait: Command = ("wait", nil)

func setTimeout(delay:NSTimeInterval, block: () -> Void) -> NSTimer {
    return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: #selector(NSOperation.main), userInfo: nil, repeats: false)
}

class WelcomeViewController: UIViewController {
    @IBOutlet weak var commandLine: TopAlignedLabel!
    var touchView: PulsingTouchView!
    
    var currentText = ""
    
    var shouldFeelTouches = false
    
    var script: [(String, String?)] = [
        wait(.Long),
        show("Last login: Sat Apr 30 14:53:04 on ttys003"),
        showln("Scholarship-Klaas:~ scholarshipapp$ "),
        wait(.Long),
        type("swift"),
        newLine,
        wait(.Short),
        showln("Welcome to Apple Swift version 2.2 (swiftlang-703.0.18.1 clang-703.0.29). Type :help for assistance."),
        showln("  1> "),
        wait,
        type("import Scholarship"),
        newLine,
        wait(.Short),
        show("  2> "),
        wait,
        type("let guide = ScholarshipGuide()"),
        wait(.Short),
        showln("guide: ScholarshipGuide = {"),
        showln("  _showInstructions = () -> Instructions"),
        showln("}"),
        showln("  3> "),
        wait(.Short),
        type("guide.showInstructions()"),
        newLine,
        wait,
        newLine,
        type("Welcome to my WWDC Scholarship app!"),
        wait(.Short),
        newLine,
        type("Wait a second, I'll pop something up real quick.."),
        wait,
        showDot,
        wait,
        newLine,
        newLine,
        type("That's the magic dot. It reveals cool things when you press it with force."),
        wait(.Short),
        newLine,
        newLine,
        type("When you're ready to review my app, try pressing the dot with some force and see what happens!"),
        wait(.Long),
        newLine,
        showln("^C")
    ]
    
    var currentCommand = 0
    var typedWordIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.touchView = PulsingTouchView(frame: CGRectMake(0,0,0,0))
        
        touchView.center.x = view.frame.width/2
        touchView.center.y = view.frame.height - 100
        
        touchView.userInteractionEnabled = false
        touchView.maskableView = view
        
        touchView.alpha = 0.0
        
        view.addSubview(touchView)
        
        performCommand(script.first!)
    }
    
    func performCommand(command: (String, String?)) {
        let header = command.0
        let value = command.1
        
        switch header {
        case "show":
            addText(value!)
            performNextCommand()
        case "showln":
            addText("\n\(value!)")
            performNextCommand()
        case "type":
            typeWord(value!) {
                self.performNextCommand()
            }
        case "wait-short":
            setTimeout(0.5, block: {
                self.performNextCommand()
            })
        case "wait":
            setTimeout(1.0, block: {
                self.performNextCommand()
            })
        case "wait-long":
            setTimeout(1.5, block: {
                self.performNextCommand()
            })
        case "show-dot":
            UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.touchView.alpha = 1.0
                }, completion: { (val) in
                    self.performNextCommand()
            })
        default:
            print("Unknown scripted command '\(header)'")
            performNextCommand()
        }
    }
    
    func typeWord(word: String, completion: () -> Void) {
        let char = word.characters[word.startIndex.advancedBy(typedWordIndex)]
        
        addText(String(char))
        
        typedWordIndex += 1
        
        if typedWordIndex < word.characters.count {
            setTimeout(0.05, block: {
                self.typeWord(word, completion: completion)
            })
        } else {
            typedWordIndex = 0
            completion()
        }
    }
    
    func performNextCommand() {
        currentCommand += 1
        if currentCommand < script.count {
            performCommand(script[currentCommand])
        } else {
            commandLine.text = currentText
            shouldFeelTouches = true
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldFeelTouches {
            if let touch = touches.first where traitCollection.forceTouchCapability == .Available {
                    let progress = touch.force / touch.maximumPossibleForce
                    
                    touchView.setTouchForce(progress)
                
                    if progress >= 1.0 {
                        shouldFeelTouches = false
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                
            }
        }
    }
    
    func addText(text: String) {
        currentText = "\(currentText)\(text)"
        commandLine.text = "\(currentText)█"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        if shouldFeelTouches {
            touchView.stopAnimation()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if shouldFeelTouches {
            touchView.resumeAnimation()
        }
    }
}
