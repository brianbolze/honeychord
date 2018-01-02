//
//  ModulatorKnob.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class ModulatorKnob : UIControl {
    
    @IBInspectable
    var backgroundImage : UIImage?
    @IBInspectable
    var slidingImage : UIImage?
    
    let minValue = CGFloat(0)
    let maxValue = CGFloat(1)
    let heightRatio = CGFloat(1.79)
    let maxTranslationRatio = CGFloat(0.79)
    let padding = CGSize(width: 2, height: 2)
    
    var slidingFrameSize : CGSize {
        return CGSize(width: frame.width-2*padding.width,
                      height: frame.height*heightRatio - 2*padding.height)
    }
    var slidingFramePosition : CGPoint {
        return CGPoint(x: padding.width, y: padding.height - (value)*frame.height*(0.78))
    }
    
    var value = CGFloat(0.5) {
        didSet {
            if value > maxValue {
                value = maxValue
            }
            if value < minValue {
                value = minValue
            }
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        backgroundColor = UIColor.clear
        if let background = backgroundImage {
            background.draw(in: rect)
        }
        if let image = slidingImage {
            let imageFrame = CGRect(x: slidingFramePosition.x, y: slidingFramePosition.y, width: slidingFrameSize.width, height: slidingFrameSize.height)
            image.draw(in: imageFrame)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let lastPoint = touch.location(in: self)
        value = 1-lastPoint.y / frame.height
        sendActions(for: .valueChanged)
        return true
    }
    
}
