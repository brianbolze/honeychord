//
//  GridHighlighting.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

import UIKit

enum GridHighlighting {
    case Roots
    case Scales(scale : Scale)
    case Chords(progression : ChordProgression)
    
    private var defaultGridGap : CGFloat {
        return 0
    }
    
    var gridGap : CGFloat {
        switch self {
        default:
            return defaultGridGap
        }
    }
}
