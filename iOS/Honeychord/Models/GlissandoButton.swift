//
//  GlissandoButton.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

protocol GlissandoGestureHandler {
    func move(_ touch : UITouch)
    func touchUp(_ touch : UITouch)
    func touchDown(_ touch : UITouch)
}

/// Don't forget to set the handler!
/// TODO : Improve support for multi-touch
class GlissandoButton : UIButton {
    
    var handler : GlissandoGestureHandler?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            handler?.touchDown(touch)
            isHighlighted = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        handler?.move(touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        handler?.touchUp(touch)
    }
}
