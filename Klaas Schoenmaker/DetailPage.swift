//
//  DetailPageViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 21-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

protocol DetailPageProtocol {
    func forcePressStarted(forceStrength: Float)
    func forcePressChanged(forceStrength: Float)
    func forcePressEnded(forceStrength: Float)
    func forcePressFinalized()
}

protocol DetailPageDelegate {
    func detailPageClosed()
}

class DetailPageController: UIViewController, DetailPageProtocol {
    var delegate: DetailPageDelegate?
    
    func forcePressStarted(forceStrength: Float) {
        print("Force press started")
    }
    
    func forcePressChanged(forceStrength: Float) {
        print("Force press changed")
    }
    
    func forcePressEnded(forceStrength: Float) {
        print("Force press ended")
    }
    
    func forcePressFinalized() {
        print("Force press finalized")
    }
}
