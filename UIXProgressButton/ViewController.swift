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
    @IBOutlet weak var progressButton2: UIXProgressButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /////
        progressButton1.setTint(UIColor.purpleColor(), forElement: .Border, forControlState: .Normal)
        progressButton1.setTint(UIColor.greenColor(), forElement: .Progress, forControlState: .Normal)
        progressButton1.controlImage = UIImage(named: "Whistle")
        progressButton1.value = 0.0
        
        ////
        progressButton2.setTint(UIColor.blueColor(), forElement: .Border, forControlState: .Normal)
        progressButton2.setTint(UIColor.greenColor(), forElement: .Progress, forControlState: .Normal)
        progressButton2.setTint(UIColor.orangeColor(), forElement: .Border, forControlState: .Selected)
        progressButton2.setTint(UIColor.yellowColor(), forElement: .Progress, forControlState: .Selected)
        progressButton2.value = 0.0
        progressButton2.controlImage = UIImage(named: "Whistle")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    var progress1Timer :NSTimer?
    @IBAction func progressButton1Pressed(sender: AnyObject) {
        progressButton1.value = 0
        progress1Timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(progress1TimerFired(_:)), userInfo: nil, repeats: true)
    }
    
    func progress1TimerFired(timer : NSTimer)
    {
        var value = progressButton1.value
        value += 0.1
        print("progress1 timer value = \(value)")
        if (value > 1.0)
        {
            timer.invalidate()
        }
        else
        {
            progressButton1.value = value
        }
    }
    
    @IBAction func enabledSwitchChanged(sender: UISwitch)
    {
        progressButton1.enabled = sender.on
        progressButton2.enabled = sender.on
    }
}

