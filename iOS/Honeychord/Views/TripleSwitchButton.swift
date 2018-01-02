//
//  TripleSwitchButton.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class TripleSwitchButton : UIButton {
    
    var selectorLightSelectedColor = UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 1.0, alpha: 1.0)
    private let selectorLightDeselectedColor = UIColor.white
    private let selectorLightRadius = CGFloat(3.5)
    private let selectorLightSpacing = CGFloat(10)
    private let selectorLightLineWidth = CGFloat(0.4)
    private let selectorLightStrokeColor = UIColor.darkGray
    
    @IBInspectable
    var leftState : String?
    @IBInspectable
    var middleState : String?
    @IBInspectable
    var rightState : String?
    
    private var selectorLights = [CAShapeLayer?](repeating: nil, count: 3)
    
    private var stateLabels : [String?] {
        return [leftState, middleState, rightState]
    }
    
    var currentState = 0 {
        didSet {
            if let title = stateLabels[currentState] {
                setTitle(title, for: .normal)
                setNeedsDisplay()
            }
        }
    }
    
    override var isHighlighted : Bool {
        didSet {
            if !isHighlighted {
                if currentState >= 2 {
                    currentState = 0
                } else {
                    currentState += 1
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        adjustLabelLocation()
        drawSelectorLights()
    }
    
    private func adjustLabelLocation() {
        titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
    }
    
    private func drawSelectorLights() {
        for i in 0...2 {
            if let shapeLayer = selectorLights[i] {
                setLightColor(state: i, shape: shapeLayer)
                
            } else {
                let shape = CAShapeLayer()
                let middleX = frame.width/2 + CGFloat(i-1)*selectorLightSpacing
                let middleY = frame.height*3/4
                
                let path = UIBezierPath(arcCenter: CGPoint(x: middleX, y: middleY), radius: selectorLightRadius,
                                        startAngle: CGFloat(0.0), endAngle: CGFloat(2*Float.pi), clockwise: true)
                
                path.lineWidth = selectorLightLineWidth
                shape.path = path.cgPath
                shape.strokeColor = selectorLightStrokeColor.cgColor
                setLightColor(state: i, shape: shape)
                layer.addSublayer(shape)
            }
        }
    }
    
    private func setLightColor(state : Int, shape : CAShapeLayer) {
        if currentState == state {
            shape.fillColor = selectorLightSelectedColor.cgColor
        } else {
            shape.fillColor = selectorLightDeselectedColor.cgColor
        }
    }
    
    
}

