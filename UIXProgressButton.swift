//
//  UIXProgressButton.swift
//  UIXProgressButton
//
//  Created by Guy Umbright on 4/26/16.
//  Copyright © 2016 Guy Umbright. All rights reserved.
//

import UIKit

func radians(degrees:Double) -> Double
{
    return degrees * M_PI/180;
}

@IBDesignable
public class UIXProgressButton: UIControl
{
    enum UIXProgressButtonElement : UInt {
        case Border = 0
        case Progress
        case Image
    }

    typealias stateTintDictionary = [UInt : UIColor]
    var elementTints : [UInt : stateTintDictionary] = [:]
    
    @IBInspectable public var borderWidth : CGFloat = 4.0
    {
        didSet {
            self.updateBorder()
        }
    }
    
    @IBInspectable public var progressWidth : CGFloat = 2.0
    {
        didSet {
            self.updateProgress()
        }
    }
    
    public override var selected: Bool
        {
        didSet {
            updateForCurrentState()
        }
    }
    
    public override var enabled: Bool
        {
        didSet {
            updateForCurrentState()
        }
    }

    @IBInspectable public var value : CGFloat = 0.0
        {
        didSet {
            if value < 0.0
            {
                value = 0.0
            } else if value > 1.0
            {
                value = 1.0
            }
            self.updateProgress()
        }
    }

    var borderLayer : CAShapeLayer = CAShapeLayer()
    var progressLayer : CAShapeLayer = CAShapeLayer()
    var controlLayer : CALayer = CALayer()

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func commonInit()
    {
        setTint(UIColor.darkGrayColor(), forElement: .Border, forControlState: .Selected)
        setTint(UIColor.grayColor(),forElement: .Progress, forControlState: .Selected)
        setTint(UIColor.grayColor(), forElement: .Border, forControlState: .Disabled)
        setTint(UIColor.lightGrayColor(),forElement: .Progress, forControlState: .Disabled)
        self.tintColor = UIColor.blackColor()
        self.addProgressLayer()
        self.addBorderLayer()
        self.addControlLayer()
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    override public func awakeFromNib() {
//        commonInit()
//    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        self.borderLayer.frame = self.bounds
        self.borderLayer.path = self.pathForBorder()
        self.progressLayer.frame = self.bounds
        self.progressLayer.path = self.pathForProgress()
        self.controlLayer.frame = self.bounds
        self.setControlImage()
        updateForCurrentState()
        print("layoutSubviews")
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func addBorderLayer()
    {
        self.borderLayer.path = self.pathForBorder()
        self.updateBorder()
        self.borderLayer.lineCap = kCALineCapRound
        self.borderLayer.backgroundColor = UIColor.clearColor().CGColor
        self.borderLayer.fillColor = UIColor.clearColor().CGColor
        self.borderLayer.shouldRasterize = true
        self.borderLayer.rasterizationScale = 2.0 * UIScreen.mainScreen().scale
        self.borderLayer.frame = self.bounds
        self.layer.addSublayer(self.borderLayer)
    }
    
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func stateTintDictionaryForElement(element : UIXProgressButtonElement) -> stateTintDictionary?
    {
        return elementTints[element.rawValue]
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setTint(tint : UIColor, forElement element : UIXProgressButtonElement, forControlState state :UIControlState)
    {
        var dict = self.stateTintDictionaryForElement(element)
        if (dict == nil)
        {
            dict = stateTintDictionary()
            elementTints[element.rawValue] = dict
        }
        elementTints[element.rawValue]![state.rawValue] = tint
        updateForCurrentState()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func tint(forElement element: UIXProgressButtonElement, forState state :UIControlState) -> UIColor?
    {
        var result : UIColor? = nil
        if let tintDict = self.stateTintDictionaryForElement(element)
        {
            result = tintDict[state.rawValue]
        }
        return result
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func tintForCurrentState(element : UIXProgressButtonElement) -> UIColor
    {
        let color = self.tint(forElement: element, forState: self.state) ?? self.tint(forElement: element, forState: .Normal)
        return color ?? UIColor.grayColor()
    }
    
//    override public var tintColor : UIColor!
//    {
//        didSet {
//            self.borderLayer.strokeColor = self.tintColor.CGColor
//            //self.controlLayer.backgroundColor = self.tintColor.CGColor
//        }
//    }
    
    public var controlImage : UIImage?
    {
        didSet {
            self.setControlImage()
        }
    }
    
//    var selectedTintColor = UIColor.blackColor()
    

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
//    func setValue(value: CGFloat, animated: Bool)
//    {
//        
//    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func pathForBorder() -> CGPath
    {
        var layerRect = self.bounds
        let inset = self.borderWidth/2 + self.progressWidth
        layerRect = CGRectInset(layerRect, inset, inset)
        
        print("border rect = \(layerRect)")
        let path = CGPathCreateWithEllipseInRect(layerRect, nil)
        return path
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func updateBorder()
    {
        let oldWidth = self.borderLayer.lineWidth
        self.borderLayer.lineWidth = self.borderWidth
        if self.borderWidth != oldWidth
        {
            self.borderLayer.path = self.pathForBorder()
            self.setControlImage()
        }
        self.borderLayer.strokeColor = self.tintColor.CGColor
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func addProgressLayer()
    {
        self.updateProgressArc()
        
        self.progressLayer.lineWidth = progressWidth
        self.progressLayer.lineCap = kCALineCapRound
        self.progressLayer.strokeColor = self.tintForCurrentState(.Progress).CGColor
        self.progressLayer.backgroundColor = UIColor.clearColor().CGColor
        self.progressLayer.fillColor = UIColor.clearColor().CGColor
        self.progressLayer.shouldRasterize = true
        self.progressLayer.rasterizationScale = 2.0 * UIScreen.mainScreen().scale
        self.progressLayer.frame = self.bounds
        self.progressLayer.transform = CATransform3DMakeRotation(CGFloat(radians(-90.0)), 0.0, 0.0, 1.0)
        self.updateProgress()
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = self.value
        self.layer.addSublayer(self.progressLayer)
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func pathForProgress() -> CGPath
    {
        var layerRect = self.bounds
        layerRect = CGRectInset(layerRect, progressWidth/2, progressWidth/2)
        print("progress rect = \(layerRect)")
        
//        let angle : Double = 360.0 * Double(self.value)
//        let arcPath = CGPathCreateMutable()
//        let start = CGFloat(radians(0.0))
//        let end = CGFloat(radians(angle))
//        CGPathAddArc(arcPath, nil, CGRectGetMidX(layerRect), CGRectGetMidY(layerRect), layerRect.size.width/2.0, start, end, false) //???
//        
//        return arcPath
        let path = CGPathCreateWithEllipseInRect(layerRect, nil)
        return path
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func updateForCurrentState()
    {
        self.tintColor = self.tintForCurrentState(.Border)
        self.controlLayer.backgroundColor = self.tintForCurrentState(.Border).CGColor

        updateBorder()
        updateProgress()
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func updateProgress()
    {
        let oldWidth = self.progressLayer.lineWidth
        self.progressLayer.lineWidth = self.progressWidth
        if self.progressWidth != oldWidth
        {
            self.progressLayer.path = self.pathForProgress()
            self.borderLayer.path = self.pathForBorder()
            self.setControlImage()
        }
        
        self.progressLayer.strokeColor = self.tintForCurrentState(.Progress).CGColor
        self.progressLayer.strokeEnd = self.value
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func addControlLayer()
    {
        self.controlLayer.backgroundColor = UIColor.clearColor().CGColor
        self.controlLayer.frame = self.bounds
        self.layer.addSublayer(self.controlLayer)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func setControlImage()
    {
        guard (self.controlImage != nil) else
        {
            return
        }
        
        let tintedImg = self.controlImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        //figure square sode lth
        var layerRect = self.bounds
        var inset = borderWidth + progressWidth
        layerRect = CGRectInset(layerRect, inset, inset)
        let side = sqrt(pow(layerRect.size.width,2)/2)
        
        let maskLayer = CALayer()//
        var frame =  self.bounds
        inset = (frame.size.width - side) / 2
        frame = CGRectInset(frame, inset, inset)
        maskLayer.frame = frame
        maskLayer.contents = tintedImg!.CGImage
        self.controlLayer.mask = maskLayer
        self.controlLayer.backgroundColor = self.tintColor.CGColor
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func updateProgressArc()
    {
        self.progressLayer.path = self.pathForProgress()
    }

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        self.tintColor = UIColor.grayColor()
        self.selected = true
        return true
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool
    {
        return true
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?)
    {
        self.selected = false
    }
    
    
}
