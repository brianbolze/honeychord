//
//  ButtonFromBezierPath.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class ButtonFromBezierPath : GlissandoButton {
    
    private var bezierPath : UIBezierPath?
    private var fillColor : UIColor?
    private var strokeColor : UIColor?
    private var lineWidth : CGFloat?
    private var innerShadow : CGFloat?
    private var gradientColors : [UIColor]?
    private var shadowColor : UIColor?
    private var glowLayer : CAShapeLayer?
    private var highlightLayer : CAShapeLayer?
    private var baseColor:  UIColor?
    
    private var highlightColor : UIColor? {
        let shadeDiff = 40
        if let c = fillColor?.rgb() {
            let red = CGFloat(max(0, c.red - shadeDiff))/255.0
            let green = CGFloat(max(0, c.green - shadeDiff))/255.0
            let blue = CGFloat(max(0, c.blue - shadeDiff))/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        return nil
    }
    
    
    override var isEnabled : Bool {
        didSet { setNeedsDisplay() }
    }
    
    override var isHighlighted : Bool {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect : CGRect) {
        if let path = bezierPath {
            if let fill = fillColor {
                if isHighlighted {
                    highlightColor!.setFill()
                } else {
                    fill.setFill()
                }
                path.fill()
            }
            if let stroke = strokeColor, let width = lineWidth {
                stroke.setStroke()
                path.lineWidth = width
                path.stroke()
            }
            if let colors = gradientColors {
                var cgcolors = [CGColor]()
                for c in colors {
                    cgcolors.append(c.cgColor)
                }
                applyGradientFill(cgcolors)
            }
            if let shadow = innerShadow, let color = shadowColor {
                addInnerShadow(color, blurRadius: shadow)
            }
        }
        switch state {
        case UIControlState.disabled:
            fillMeUp(UIColor(white: 0.0, alpha: 0.11))
        default: break
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bezierPath!.contains(point)
    }
    
    ////////////////////////////////
    ///////// Initializers /////////
    ////////////////////////////////
    
    init(frame: CGRect, path : UIBezierPath, fill : UIColor?, gradientColors : [UIColor]?, stroke : UIColor?, lineWidth : CGFloat?, innerShadow: CGFloat?, shadowColor: UIColor?) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        bezierPath = path
        fillColor = fill
        baseColor = fill
        strokeColor = stroke
        self.gradientColors = gradientColors
        self.innerShadow = innerShadow
        self.lineWidth = lineWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func changeAppearance(fillColor : UIColor?, gradientColors : [UIColor]?, strokeColor : UIColor?, lineWidth : CGFloat?, shadowColor : UIColor?) {
        if fillColor == self.fillColor && strokeColor == self.strokeColor && lineWidth == self.lineWidth &&
            shadowColor == self.shadowColor {
            if (gradientColors == nil && self.gradientColors == nil) {
                return
            } else if gradientColors?[0] == self.gradientColors?[0] {
                return
            }
        }
        self.gradientColors = gradientColors
        self.fillColor = fillColor
        self.baseColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.shadowColor = shadowColor
        setNeedsDisplay()
    }
    
    func addGlow(color : UIColor) {
        fillColor = color
        setNeedsDisplay()
    }
    
    func removeGlow() {
        fillColor = baseColor
        setNeedsDisplay()
    }
    
    private func applyGradientFill(_ colors : [CGColor]) {
        let context = UIGraphicsGetCurrentContext()
        let locations : [CGFloat] = [0.0, 1.0]
        bezierPath?.applyLinearGradientInContext(context: context!, colors: colors, locations: locations)
    }
    
    private func addInnerShadow(_ shadowColor : UIColor, blurRadius : CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        bezierPath?.drawInnerShadowInContext(context: context!, shadowColor: shadowColor.cgColor, offset: .zero, blurRadius: blurRadius)
    }
    
    private func fillMeUp(_ color : UIColor) {
        let glowRect = bezierPath!
        color.setFill()
        glowRect.fill()
    }
}
