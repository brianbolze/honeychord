//
//  UIBezierPath+Extension.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit


extension UIBezierPath {
    
    /// FIXME: This implementation is SUPER slow... needs refactoring
    func drawInnerShadowInContext(context : CGContext, shadowColor : CGColor, offset : CGSize, blurRadius : CGFloat) {
        context.saveGState()
        context.addPath(cgPath)
        context.clip()
        context.setAlpha(shadowColor.alpha)
        context.beginTransparencyLayer(in: bounds, auxiliaryInfo: nil)
        context.setShadow(offset: offset, blur: blurRadius, color: shadowColor)
        context.setBlendMode(.sourceOut)
        context.setFillColor(shadowColor)
        context.addPath(cgPath)
        context.fillPath()
        context.endTransparencyLayer()
        context.restoreGState()
    }
    
    func applyLinearGradientInContext(context : CGContext, colors : [CGColor], locations : [CGFloat]) {
        context.saveGState()
        addClip()
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        context.drawLinearGradient(gradient!, start: .zero, end: CGPoint(x: 0, y: bounds.height), options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
    }
    
}

