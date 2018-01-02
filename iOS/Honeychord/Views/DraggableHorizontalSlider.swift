//
//  DraggableHorizontalSlider.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class DraggableHorizontalSlider : UIControl {
    
    @IBInspectable var knob : UIImage?
    @IBInspectable var backgroundImage : UIImage?
    
    let minValue = CGFloat(0)
    let maxValue = CGFloat(1)
    
    
    private let knobPadding = CGFloat(0)
    private let circlePadding = CGFloat(4.5)
    private let circleLeftPadding = CGFloat(5)
    private let circleColor = UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 1.0, alpha: 1.0)
    private let circleBorderColor = UIColor.gray
    private let circleBorderWidth = CGFloat(1)
    private var knobHeight : CGFloat {
        return frame.height
    }
    private var circleRadius : CGFloat {
        return (frame.height - circlePadding*3)/4
    }
    private var numCircles : Int {
        return Int((frame.width - circlePadding*2)/(circleRadius*2+circlePadding))
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
        if let image = backgroundImage {
            image.draw(in: rect)
        }
        drawAllCircles()
        if let image = knob {
            let x = ((frame.width-knobHeight-knobPadding*2) * value) + knobPadding
            let f = CGRect(x: x, y: knobPadding, width: knobHeight, height: knobHeight)
            image.draw(in: f)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let lastPoint = touch.location(in: self)
        value = lastPoint.x / frame.width
        sendActions(for: .valueChanged)
        return true
    }
    
    private func drawAllCircles() {
        var x = circleLeftPadding + circlePadding + circleRadius
        for _ in 0..<numCircles {
            let sliderPos = ((frame.width-knobHeight-knobPadding*2) * value) + knobPadding
            var opacity = CGFloat(1)
            var difference = x - sliderPos
            if difference > 5 {
                opacity = 0
            } else if (difference > -5) {
                difference += 5
                difference /= 10
                opacity = 1-difference
            }
            drawCircles(x: x, opacity: opacity)
            x += circlePadding + circleRadius*2
        }
    }
    
    private func drawCircles(x : CGFloat, opacity : CGFloat) {
        let y1 = circlePadding + circleRadius
        let y2 = y1 + circlePadding + circleRadius*2
        let path1 = UIBezierPath(arcCenter: CGPoint(x: x, y: y1), radius: circleRadius, startAngle: 0, endAngle: CGFloat(2*Float.pi), clockwise: true)
        let path2 = UIBezierPath(arcCenter: CGPoint(x: x, y: y2), radius: circleRadius, startAngle: 0, endAngle: CGFloat(2*Float.pi), clockwise: true)
        circleColor.withAlphaComponent(opacity).setFill()
        circleBorderColor.setStroke()
        path1.lineWidth = circleBorderWidth
        path2.lineWidth = circleBorderWidth
        path1.fill()
        path2.fill()
        path1.stroke()
        path2.stroke()
    }
    
    
}
