//
//  MIDIInstrument.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

///
/// See `Keyboards.sf2` file
///
enum MIDIInstrument : CustomStringConvertible {
    // Keyboards
    case GrandPiano
    case Rhodes
    case Harpsichord
    case Organ
    
    // Synths
    case BigPad
    
    var description : String {
        switch self {
        case .GrandPiano:
            return "Grand Piano"
        case .Organ:
            return "Organ"
        case .Rhodes:
            return "Electric Piano"
        case .BigPad:
            return "Synth"
        case .Harpsichord:
            return "Harpsichord"
        }
    }
    
    var presetNumber : UInt8 {
        switch self {
        case .GrandPiano:
            return 0
        case .Rhodes:
            return 1
        case .Harpsichord:
            return 2
        case .Organ:
            return 3
        case .BigPad:
            return 4
        }
    }
    
}
