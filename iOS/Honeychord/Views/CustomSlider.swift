//
//  CustomSlider.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider : UIControl {
    
    @IBInspectable var knob : UIImage?
    @IBInspectable var backgroundImage : UIImage?
    
    let minValue = CGFloat(0)
    let maxValue = CGFloat(1)
    
    var value = CGFloat(0.5) {
        didSet {
            // Might need to make more efficient
            if value > maxValue {
                value = maxValue
            }
            if value < minValue {
                value = minValue
            }
            setNeedsDisplay()
        }
    }
    
    private let knobHeight = CGFloat(20)
    private let barPadding = CGFloat(4)
    private let barWidth = CGFloat(4)
    private let barCorners = CGFloat(1)
    private let barColor = UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 1.0, alpha: 1.0)
    private var barX : CGFloat {
        return frame.width/2 - barWidth/2
    }
    private var barY : CGFloat {
        let max = frame.height - barPadding
        return (1-value)*max
    }
    private var barHeight : CGFloat {
        let max = frame.height - barPadding
        return value*max
    }
    
    override func draw(_ rect: CGRect) {
        if let image = backgroundImage {
            image.draw(in: rect)
        }
        drawBar()
        if let image = knob {
            let y = (frame.height * (1-value)) - knobHeight/2
            let r = CGRect(x: 3, y: y, width: frame.width-6, height: knobHeight)
            image.draw(in: r)
        }
    }
    
    private func drawBar() {
        let f = CGRect(x: barX, y: barY, width: barWidth, height: barHeight)
        let path = UIBezierPath(roundedRect: f, cornerRadius: barCorners)
        barColor.setFill()
        path.fill()
    }
    
}
