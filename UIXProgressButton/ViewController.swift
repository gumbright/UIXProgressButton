//
//  ViewController.swift
//  UIXProgressButton
//
//  Created by Guy Umbright on 9/3/16.
//  Copyright © 2016 Guy Umbright. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressButton1: UIXProgressButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressButton1.setTint(UIColor.purpleColor(), forElement: .Border, forControlState: .Normal)
        progressButton1.setTint(UIColor.greenColor(), forElement: .Progress, forControlState: .Normal)
        progressButton1.controlImage = UIImage(named: "Whistle")
        //progressButton1.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

