//
//  GridView.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

protocol GridViewDelegate {
    var gridGap : CGFloat { get }
    var buttonHidingOn: Bool { get }
    var buttonDisablingOn: Bool { get }
    func titleForGridLocation(row : Int, col : Int) -> String
    func buttonPress(row: Int, col : Int, velocity: Int)
    func buttonRelease(row: Int, col: Int)
    func buttonVebrato(row : Int, col: Int, value : Int)
    func isButtonGlowing(row : Int, col : Int) -> Bool
    func isButtonHidden(row: Int, col: Int) -> Bool
    func buttonColoring(row: Int, col : Int) -> HexButton.HexButtonColorState
}


class GridView: UIView, GlissandoGestureHandler, CAAnimationDelegate {
    
    var gridDelegate : GridViewDelegate?
    
    var touchIndicatorEnabled = false
    private let touchIndicatorRadius = CGFloat(17)
    private let touchIndicatorOffset = CGPoint(x: 0, y: -10)
    private let touchIndicatorColor = UIColor(red: 0, green: 167.0/255.0, blue: 1.0, alpha: 0.8)
    private let touchIndicatorAnimationDuration = CFTimeInterval(0.2)
    private let touchHitRadius = CGFloat(12)
    
    private let hexagonDefaultWidth = CGFloat(160)
    private let hexagonFontSize = CGFloat(14.0)
    private let hexagonFontName = "Helvetica Neue"
    private let hexagonBlurRadius = CGFloat(14.0)
    private let hexagonDefaultColor = UIColor(white: 0.75, alpha: 1.0)
    private let hexagonDefaultTextColor = UIColor.white.withAlphaComponent(0.7)
    private let hexagonDarkTextColor = UIColor.darkGray.withAlphaComponent(0.7)
    private let hexagonDefaultGradientColors = [UIColor(white: 230.0/255.0, alpha: 1.0),
                                                UIColor(white: 141.0/255.0, alpha: 1.0)]
    
    private var buttons = [[UIButton?]]()
    private var buttonScanner : HexGridScanner?
    private var touchHits = [UITouch : [String : HexButton]]()
    private var touchIndicators = [UITouch : CAShapeLayer]()
    private var animationQueue = [CAShapeLayer]()
    
    private var gridGap : CGFloat {
        return gridDelegate!.gridGap
    }
    
    var hexWidth = CGFloat(100) {
        didSet {
            hexWidth = max(75, hexWidth)
            hexWidth = min(225, hexWidth)
            setNeedsDisplay()
        }
    }
    private var hexHeight : CGFloat {
        return hexWidth * CGFloat(sin(Float.pi/3))
    }
    var numCols : Int {
        return Int(frame.width/(hexWidth*2))+3
    }
    var numRows : Int {
        return min(19, Int(2*frame.height/hexHeight)+3)
    }
    
    override func draw(_ rect: CGRect) {
        for buttonArray in buttons {
            for button in buttonArray {
                if let b = button {
                    b.removeFromSuperview()
                }
            }
        }
        buttons = [[UIButton?]](repeating: [UIButton?](repeating: nil, count: numCols), count: numRows)
        buttonScanner = HexGridScanner(hexSize: CGSize(width: hexWidth, height: hexHeight), gridGap: gridGap)
        addHexButtons()
        updateHidingAndDisabling()
    }
    
    // For touch indicator
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !animationQueue.isEmpty {
            let shape = animationQueue.remove(at: 0)
            shape.removeFromSuperlayer()
        }
    }
    
    func updateColoring() {
        clearTouchIndicators()
        if let delegate = gridDelegate {
            for buttonArray in buttons {
                for button in buttonArray {
                    if let b = button as? HexButton {
                        b.coloringState = delegate.buttonColoring(row: b.row, col: b.col)
                        // b.baseLayer = delegate.buttonBaseLayer(b.row, col: b.col)
                    }
                }
            }
        }
        
    }
    
    func updateGlow() {
        if let delegate = gridDelegate {
            for buttonArray in buttons {
                for button in buttonArray {
                    if let b = button as? HexButton {
                        if delegate.isButtonGlowing(row: b.row, col: b.col) {
                            b.coloringState = HexButton.HexButtonColorState.glowing
                        } else {
                            b.coloringState = delegate.buttonColoring(row: b.row, col: b.col)
                        }
                    }
                }
            }
        }
    }
    
    func updateHidingAndDisabling() {
        if let delegate = gridDelegate {
            let hidingOn = delegate.buttonHidingOn
            let disablingOn = delegate.buttonDisablingOn
            for buttonArray in buttons {
                for button in buttonArray {
                    if let b = button as? HexButton {
                        if hidingOn {
                            b.isHidden = delegate.isButtonHidden(row: b.row, col: b.col)
                        } else {
                            b.isHidden = false
                        }
                        if disablingOn {
                            b.isEnabled = !delegate.isButtonHidden(row: b.row, col: b.col)
                        } else {
                            b.isEnabled = true
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            touchDown(t)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            move(t)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            touchUp(t)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
            return nil
        }
        if self.point(inside: point, with: event) {
            let loc = buttonScanner?.getGridLocation(forPoint: point)
            if let coordinate = loc {
                let x = coordinate.x
                let y = coordinate.y
                if let b = buttons[safe: x]?[safe: y] {
                    let convertedPoint = b!.convert(point, from: self)
                    let hitTestView = b!.hitTest(convertedPoint, with: event)
                    if (hitTestView != nil) {
                        return hitTestView
                    }
                }
            }
            
            return self
        }
        return nil
    }
    
    
    //////////////////////
    // Use these to perform hit detection on Grid "Buttons"
    //////////////////////
    func touchDown(_ touch : UITouch) {
        let touchLocation = touch.location(in: self)
        touchHits[touch] = [String : HexButton]()
        for location in hitTestLocations(location: touchLocation) {
            
            let result = hitTest(location, with: nil)
            
            if let button = result as? HexButton {
                touchHits[touch]?[button.title(for: .normal)!] = button
                let relativeLocation = buttonTouchLocation(touch: touch, button: button)
                if !button.isHighlighted {
                    enterButton(button: button, location: relativeLocation)
                }
            }
        }
        addTouchIndicator(touch: touch, location: touchLocation)
    }
    
    func move(_ touch: UITouch) {
        let touchLocation = touch.location(in: self)
        var newHits = [String : HexButton]()
        for location in hitTestLocations(location: touchLocation) {
            let result = hitTest(location, with: nil)
            if let button = result as? HexButton {
                let title = button.title(for: .normal)!
                newHits[title] = button
                let relativeLocation = buttonTouchLocation(touch: touch, button: button)
                if !button.isHighlighted {
                    enterButton(button: button, location: relativeLocation)
                } else {
                    vebrato(button: button, location: relativeLocation)
                }
            }
        }
        checkMoveChanges(touch: touch, newHits: newHits)
        updateTouchIndicator(touch: touch, location: touchLocation)
    }
    
    func touchUp(_ touch: UITouch) {
        resetButtons(touch: touch)
        removeLastTouchIndicator(touch: touch)
    }
    
    // Definitely needs refactoring
    private func buttonTouchLocation(touch : UITouch, button : UIButton) -> CGFloat {
        var relativeLocation = touch.location(in: button).y
        relativeLocation = relativeLocation + 30
        relativeLocation = max(relativeLocation, 20)
        relativeLocation = min(relativeLocation, 107)
        relativeLocation = 127 - relativeLocation
        return relativeLocation
    }
    
    private func enterButton(button : HexButton, location : CGFloat) {
        let velocity = max(60,Int(location))
        if let d = gridDelegate {
            d.buttonPress(row: button.row, col: button.col, velocity: velocity)
        }
        button.isHighlighted = true
    }
    
    private func vebrato(button : HexButton, location : CGFloat) {
        if let d = gridDelegate {
            d.buttonVebrato(row: button.row, col: button.col, value: Int(location))
        }
    }
    
    private func exitButton(button : HexButton) {
        button.isHighlighted = false
        if let d = gridDelegate {
            d.buttonRelease(row: button.row, col: button.col)
        }
    }
    
    private func hitTestLocations(location : CGPoint) -> [CGPoint] {
        // return [location]
        return [location, CGPoint(x: location.x-touchHitRadius, y: location.y),
                CGPoint(x: location.x+touchHitRadius, y: location.y),
                CGPoint(x: location.x, y: location.y+touchHitRadius),
                CGPoint(x: location.x, y: location.y-touchHitRadius),
                CGPoint(x: location.x+(touchHitRadius/sqrt(2)), y: location.y+(touchHitRadius/sqrt(2))),
                CGPoint(x: location.x-(touchHitRadius/sqrt(2)), y: location.y+(touchHitRadius/sqrt(2))),
                CGPoint(x: location.x+(touchHitRadius/sqrt(2)), y: location.y-(touchHitRadius/sqrt(2))),
                CGPoint(x: location.x-(touchHitRadius/sqrt(2)), y: location.y-(touchHitRadius/sqrt(2)))
        ]
    }
    
    private func checkMoveChanges(touch : UITouch, newHits : [String : HexButton]) {
        let oldHits = touchHits[touch]!
        for title in oldHits.keys {
            if newHits[title] == nil {
                exitButton(button: oldHits[title]!)
            }
        }
        touchHits[touch] = newHits
    }
    
    private func resetButtons(touch : UITouch) {
        let hits = touchHits[touch]
        for button in hits!.values {
            if button.isHighlighted {
                exitButton(button: button)
            }
        }
        touchHits[touch] = nil
    }
    
    private func addHexButtons() {
        var x = -hexWidth
        var y = -hexHeight
        for row in 0..<numRows {
            x = ((CGFloat(row%2)*3) - 7) * hexWidth/4   // either -7/4 or -1 hexWidth
            y += hexHeight/2 + gridGap
            for col in 0..<numCols {
                x += hexWidth*3/2
                x += 2*gridGap*sqrt(3)
                var xLoc = x
                if row%2==1 {
                    xLoc+=gridGap*sqrt(3)
                }
                addHex(x: xLoc, y: y, row: row, col: col)
            }
        }
    }
    
    private func addHex(x : CGFloat, y : CGFloat, row : Int, col : Int) {
        let buttonFrame = CGRect(x: x, y: y, width: hexWidth, height: hexHeight)
        let button = HexButton(frame: buttonFrame, row: row, col: col)
        if let d = gridDelegate {
            // button.setTitle("\(row), \(col)", forState: .Normal)
            button.setTitle(d.titleForGridLocation(row: row, col: col), for: .normal)
            button.setTitleColor(hexagonDefaultTextColor, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: hexagonFontSize)
            
            if d.isButtonGlowing(row: row, col: col) {
                button.coloringState = HexButton.HexButtonColorState.glowing
            } else {
                button.coloringState = d.buttonColoring(row: row, col: col)
            }
        }
        button.handler = self
        buttons[row][col] = button
        addSubview(button)
    }
    
    
    /// Code for touch indicator trails
    
    private func addTouchIndicator(touch : UITouch, location : CGPoint) {
        if touchIndicatorEnabled {
            let shape = CAShapeLayer()
            let startPath = UIBezierPath(arcCenter: touchIndicatorOffset, radius: touchIndicatorRadius, startAngle: 0, endAngle: CGFloat(2*Float.pi), clockwise: true)
            shape.position = location
            shape.path = startPath.cgPath
            shape.fillColor = touchIndicatorColor.cgColor
            shape.shadowColor = touchIndicatorColor.cgColor
            shape.shadowOpacity = 1.0
            shape.shadowOffset = .zero
            shape.shadowRadius = 7.0
            shape.opacity = 1.0
            shape.filters = [CIFilter(name: "CIGaussianBlur") as AnyObject]
            layer.addSublayer(shape)
            touchIndicators[touch] = shape
        }
    }
    
    private func updateTouchIndicator(touch : UITouch, location : CGPoint) {
        if touchIndicatorEnabled {
            if let last = touchIndicators[touch] {
                addTouchIndicatorAnimation(shape: last)
                addTouchIndicator(touch: touch, location: location)
            }
        }
    }
    
    private func removeLastTouchIndicator(touch : UITouch) {
        if touchIndicatorEnabled {
            if let shape = touchIndicators[touch] {
                addTouchIndicatorAnimation(shape: shape)
            }
            touchIndicators.removeValue(forKey: touch)
        }
    }
    
    private func addTouchIndicatorAnimation(shape : CAShapeLayer) {
        if touchIndicatorEnabled {
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0.8
            opacityAnimation.toValue = 0.0
            opacityAnimation.duration = touchIndicatorAnimationDuration
            opacityAnimation.delegate = self as CAAnimationDelegate
            opacityAnimation.autoreverses = false
            shape.add(opacityAnimation, forKey: "opacity")
            
            let startPath = UIBezierPath(arcCenter: touchIndicatorOffset, radius: touchIndicatorRadius*0.8, startAngle: 0, endAngle: CGFloat(2*Float.pi), clockwise: true)
            let endPath = UIBezierPath(arcCenter: touchIndicatorOffset, radius: 0, startAngle: 0, endAngle: CGFloat(2*Float.pi), clockwise: true)
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.fromValue = startPath.cgPath
            pathAnimation.toValue = endPath.cgPath
            pathAnimation.duration = touchIndicatorAnimationDuration
            pathAnimation.delegate = self as CAAnimationDelegate
            shape.add(pathAnimation, forKey: "path")
            shape.path = endPath.cgPath
            
            animationQueue.append(shape)
        }
    }
    
    private func clearTouchIndicators() {
        if touchIndicatorEnabled {
            for s in touchIndicators.values {
                s.removeFromSuperlayer()
            }
        }
    }
    
}

