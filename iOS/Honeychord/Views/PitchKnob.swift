//
//  PitchKnob.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

@IBDesignable
class PitchKnob : ModulatorKnob {
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        value = 0.5
        sendActions(for: .valueChanged)
    }
    
}
