//
//  HexButton.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class HexButton : GlissandoButton {
    
    let row : Int
    let col : Int
    
    private let transitionAnimationDuration = 0.06
    private let animatedHighlight = false
    
    // For Hexagon drawing
    private var longside : CGFloat  { return max(frame.width,frame.height) }
    private var a : CGFloat         { return longside/2 }
    private var b : CGFloat         { return a * CGFloat(sin(Float.pi/3)) }
    private var c : CGFloat         { return a / 2 }
    private var x : CGFloat         { return a / 20 } // change this for rounding radius
    private var y : CGFloat         { return x * sqrt(3) }
    private var w : CGFloat         { return x / 2 }
    private var u : CGFloat         { return w * sqrt(3) }
    
    private var myPath : UIBezierPath {
        return myRoundedPath
    }
    private var myUnRoundedPath : UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: c, y: 0))
        path.addLine(to: CGPoint(x: a+c, y: 0))
        path.addLine(to: CGPoint(x: 2*a, y: b))
        path.addLine(to: CGPoint(x: a+c, y: 2*b))
        path.addLine(to: CGPoint(x: c, y: 2*b))
        path.addLine(to: CGPoint(x: 0, y: b))
        path.close()
        return path
    }
    private var myRoundedPath : UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: c+x, y: 0))
        path.addLine(to: CGPoint(x: a+c-x, y: 0))
        path.addQuadCurve(to: CGPoint(x: a+c+(x/2), y: y/2), controlPoint: CGPoint(x: a+c, y: 0))
        path.addLine(to: CGPoint(x: 2*a-w, y: b-u))
        path.addQuadCurve(to: CGPoint(x: 2*a-w, y: b+u), controlPoint: CGPoint(x: 2*a, y: b))
        path.addLine(to: CGPoint(x: c+a+(x/2), y: 2*b-(y/2)))
        path.addQuadCurve(to: CGPoint(x: a+c-x, y: 2*b), controlPoint: CGPoint(x: c+a, y: 2*b))
        path.addLine(to: CGPoint(x: c+x, y: 2*b))
        path.addQuadCurve(to: CGPoint(x: c-(x/2), y: 2*b-(y/2)), controlPoint: CGPoint(x: c, y: 2*b))
        path.addLine(to: CGPoint(x: w, y: b+u))
        path.addQuadCurve(to: CGPoint(x: w, y: b-u), controlPoint: CGPoint(x: 0, y: b))
        path.addLine(to: CGPoint(x: c-x/2, y: y/2))
        path.addQuadCurve(to: CGPoint(x: c+x, y: 0), controlPoint: CGPoint(x: c, y: 0))
        path.close()
        return path
    }
    
    var coloringState : HexButtonColorState = HexButtonColorState.normal {
        didSet {
            setNeedsColorDisplay()
        }
    }
    
    override var isHighlighted : Bool {
        didSet {
            if animatedHighlight {
                if isHighlighted {
                    addHighlightAnimation()
                } else {
                    addUnhighlightAnimation()
                }
            }
        }
    }
    
    init(frame: CGRect, row: Int, col: Int) {
        self.row = row
        self.col = col
        super.init(frame: frame)
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    override init(frame: CGRect) {
        row = 0
        col = 0
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        row = 0
        col = 0
        super.init(coder: aDecoder)!
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setNeedsColorDisplay()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return myPath.contains(point)
    }
    
    
    private func setNeedsColorDisplay() {
        
        var image = HexButtonColorState.cachedImages[coloringState]
        var highlightedImage = HexButtonColorState.cachedHighlightedImages[coloringState]
        if image == nil {
            drawImageForState(coloringState: coloringState, isHighlighted: false)
        }
        if highlightedImage == nil {
            drawImageForState(coloringState: coloringState, isHighlighted: true)
        }
        
        image = HexButtonColorState.cachedImages[coloringState]!
        highlightedImage = HexButtonColorState.cachedHighlightedImages[coloringState]!
        
        setBackgroundImage(image!, for: .normal)
        setBackgroundImage(highlightedImage!, for: .highlighted)
        
    }
    
    private func drawImageForState(coloringState state: HexButtonColorState, isHighlighted: Bool) {
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()!
        let myPath = self.myPath
        
        // Draw background
        if let gradientColors = state.gradientColors { // Draw Gradient
            
            let gradientLayer = CAGradientLayer()
            context.saveGState()
            myPath.addClip()
            
            gradientLayer.frame = frame
            gradientLayer.colors = gradientColors
            gradientLayer.locations = state.gradientLocations as [NSNumber]
            
            gradientLayer.render(in: context)
            context.restoreGState()
            
        } else if let fillColor = state.fillColor { // Draw plain fill
            context.saveGState()
            context.addPath(myPath.cgPath)
            context.setFillColor(fillColor.cgColor)
            context.fillPath()
            context.restoreGState()
        }
        
        // Draw border
        if let strokeColor = state.strokeColor, let lineWidth = state.lineWidth {
            context.saveGState()
            context.addPath(myPath.cgPath)
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(lineWidth)
            context.strokePath()
            context.restoreGState()
        }
        
        // Draw inner shadow
        let innerShadowColor : UIColor?
        let innerShadowBlurRadius : CGFloat?
        if isHighlighted {
            innerShadowColor = state.highlightedInnerShadowColor
            innerShadowBlurRadius = state.highlightedInnerShadowBlurRadius
        } else {
            innerShadowColor = state.innerShadowColor
            innerShadowBlurRadius = state.innerShadowBlurRadius
        }
        
        if let shadowColor = innerShadowColor, let blurRadius = innerShadowBlurRadius {
            context.addPath(myPath.cgPath)
            context.clip()
            context.setAlpha(shadowColor.cgColor.alpha)
            context.beginTransparencyLayer(in: bounds, auxiliaryInfo: nil)
            context.setShadow(offset: .zero, blur: blurRadius, color: shadowColor.cgColor)
            context.setBlendMode(.sourceOut)
            context.setFillColor(shadowColor.cgColor)
            context.addPath(myPath.cgPath)
            context.fillPath()
            context.endTransparencyLayer()
        }
        
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if isHighlighted {
            HexButtonColorState.cachedHighlightedImages[coloringState] = capturedImage
            setBackgroundImage(capturedImage, for: .highlighted)
        } else {
            HexButtonColorState.cachedImages[coloringState] = capturedImage
            setBackgroundImage(capturedImage, for: .normal)
        }
        
        
    }
    
    
    private func addHighlightAnimation() {
        let highlightScale = CGFloat(0.95)
        let addAnimationDuration = TimeInterval(0.2)
        let transform = CGAffineTransform(scaleX: highlightScale, y: highlightScale)
        superview?.bringSubview(toFront: self)
        UIView.animate(withDuration:
            addAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: -0.2,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.transform = transform },
            completion: {_ in }
        )
    }
    
    private func addUnhighlightAnimation() {
        let removeAnimationDuration = TimeInterval(0.2)
        let transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration:
            removeAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: -0.2,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: { self.transform = transform },
            completion: {_ in }
        )
        
    }
    
    enum HexButtonColorState {
        case normal
        case root
        case outOfScale
        case glowing
        
        static var cachedImages = [HexButtonColorState: UIImage?]()
        static var cachedHighlightedImages = [HexButtonColorState: UIImage?]()
        
        var strokeColor: UIColor? {
            switch self {
            default:
                return UIColor.darkGray
            }
        }
        
        var lineWidth: CGFloat? {
            switch self {
            default:
                return 1.5
            }
        }
        
        var fillColor : UIColor? {
            switch self {
            default:
                return nil
            }
        }
        
        var gradientLocations: [CGFloat] {
            switch self{
            default:
                return [0.2, 0.7, 1]
            }
        }
        
        var gradientColors: [CGColor]? {
            switch self {
            case .normal:
                return [UIColor(netHex: 0xEBEBEB).cgColor, UIColor(netHex: 0xBEBEBE).cgColor, UIColor(netHex: 0xA7A7A7).cgColor]
            case .root:
                return [UIColor(netHex: 0xB0B0B0).cgColor, UIColor(netHex: 0x7E7E7E).cgColor, UIColor(netHex: 0x5D5D5D).cgColor]
            case .outOfScale:
                return [UIColor(netHex: 0x828282).cgColor, UIColor(netHex: 0x505050).cgColor, UIColor(netHex: 0x1E1E1E).cgColor]
            case .glowing:
                return [UIColor(netHex: 0xA9D3FF).cgColor, UIColor(netHex: 0x49A3FF).cgColor, UIColor(netHex: 0x2A93FD).cgColor]
            }
        }
        
        var highlightedGradientColors: [CGColor]? {
            return nil
        }
        
        var innerShadowColor: UIColor? {
            switch self {
            default:
                return UIColor(white: 0.2, alpha: 1)
            }
        }
        
        var highlightedInnerShadowColor: UIColor? {
            switch self {
            default:
                return UIColor(white: 0, alpha: 0.9)
            }
        }
        
        var innerShadowBlurRadius: CGFloat? {
            switch self {
            default:
                return 15.0
            }
        }
        
        var highlightedInnerShadowBlurRadius: CGFloat? {
            switch self {
            default:
                return 25.0
            }
        }
        
        
        
    }
    
}

