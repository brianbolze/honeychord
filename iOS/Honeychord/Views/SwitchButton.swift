//
//  SwitchButton.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class SwitchButton : UIButton {
    
    @IBInspectable
    var onImage : UIImage?
    @IBInspectable
    var offImage : UIImage?
    @IBInspectable
    var on : Bool = true {
        didSet {
            if on {
                setImage(onImage, for: .normal)
            } else {
                setImage(offImage, for: .normal)
            }
        }
    }
    
    override var isHighlighted : Bool {
        didSet {
            if !isHighlighted {
                on = !on
            }
        }
    }
    
}
