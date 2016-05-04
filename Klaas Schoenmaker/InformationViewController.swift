//
//  InformationViewController.swift
//  Klaas Schoenmaker
//
//  Created by Klaas Schoenmaker on 25-04-16.
//  Copyright © 2016 KlaasApps. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var titleString: String!
    var image: UIImage!
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = titleString
        
        self.imageView.image = image
        
        self.textLabel.text = text
        self.textLabel.sizeToFit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
