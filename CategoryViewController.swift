//
//  CategoryViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 19-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

final class CategoryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var index: Int!
    var dotRaster: WWDCDotRaster!
    
    var titleString: String!
    
    var descriptionString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleString
        descriptionLabel.text = descriptionString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touches began in this dude")
    }
}
