//
//  Scale.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public enum Scale {
    case Major
    case MajorPentatonic
    case Minor
    case HarmonicMinor
    case MelodicMinor
    case MinorPentatonic
    case Blues
    
    public static var knownScales : [Scale] {
        return [.Major, .Minor, .HarmonicMinor, .MelodicMinor,
                .Blues, .MajorPentatonic, .MinorPentatonic]
    }
    
    public var name : String {
        switch self {
        case .Major:
            return "Major"
        case .MelodicMinor:
            return "Melodic Minor"
        case .Minor:
            return "Minor"
        case .HarmonicMinor:
            return "Harmonic Minor"
        case .Blues:
            return "Blues"
        case .MajorPentatonic:
            return "Major Pentatonic"
        case .MinorPentatonic:
            return "Minor Pentatonic"
        }
    }
    
    public var noteMap : [Int] {
        switch self {
        case .Major:
            return [0,2,4,5,7,9,11]
        case .Minor:
            return [0,2,3,5,7,8,10]
        case .MelodicMinor:
            return [0,2,3,5,7,9,11]
        case .HarmonicMinor:
            return [0,2,3,5,7,8,11]
        case .Blues:
            return [0,3,5,6,7,10]
        case .MajorPentatonic:
            return [0,2,4,7,9]
        case .MinorPentatonic:
            return [0,3,5,7,10]
        }
    }
    
    public func toNote(id : Int) -> Int {
        let octave = Int(id/noteMap.count)
        return 12*octave + noteMap[id%noteMap.count]
    }
    
    public func inScale(note : Int) -> Bool {
        let interval = note%12
        return noteMap.contains(interval)
    }
}


// MARK: - CustomStringConvertible

extension Scale: CustomStringConvertible {
    public var description: String {
        return name
    }
}
