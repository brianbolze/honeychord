//
//  Chord.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public enum Chord {
    case Major
    case Minor
    case Augmented
    case Diminished
    case Sus4
    case Sus2
    case Major7
    case Major6
    case Dominant7
    case Minor7
    case Minor6
    case Minor7flat5
    case Diminished7
    case Ninth
    case Minor9
    case Eleventh
    
    public var intervals : [Int] {
        switch self {
        case .Major:
            return [0,4,7]
        case .Minor:
            return [0,3,7]
        case .Augmented:
            return [0,4,8]
        case .Diminished:
            return [0,3,6]
        case .Sus4:
            return [0,5,7]
        case .Sus2:
            return [0,2,7]
        case .Major7:
            return [0,4,7,11]
        case .Major6:
            return [0,4,7,9]
        case .Dominant7:
            return [0,4,7,10]
        case .Minor7:
            return [0,3,7,10]
        case .Minor6:
            return [0,3,7,9]
        case .Minor7flat5:
            return [0,3,6,10]
        case .Diminished7:
            return [0,3,6,9]
        case .Ninth:
            return [0,4,7,14]
        case .Minor9:
            return [0,3,7,14]
        case .Eleventh:
            return [0,4,10,17]
        }
    }
    
    public var abbreviation : String {
        switch self {
        case .Major:
            return "Maj"
        case .Minor:
            return "min"
        case .Augmented:
            return "Aug"
        case .Diminished:
            return "dim"
        case .Sus4:
            return "sus4"
        case .Sus2:
            return "sus2"
        case .Major7:
            return "Maj7"
        case .Major6:
            return "6"
        case .Dominant7:
            return "7"
        case .Minor7:
            return "min7"
        case .Minor6:
            return "min6"
        case .Minor7flat5:
            return "min7♭5"
        case .Diminished7:
            return "dim7"
        case .Ninth:
            return "9"
        case .Minor9:
            return "m9"
        case .Eleventh:
            return "11"
        }
    }
    
    public func isChordTone(note : Note, withRoot : Note) -> Bool {
        let c = chordTones(root: withRoot)
        return c.index(of: note.midiNote%12) != nil
    }
    
    public func chordTones(root : Note) -> [Int] {
        let baseChord = notes(root: root)
        var chordTones = [Int]()
        for n in baseChord {
            chordTones.append(n.midiNote%12)
        }
        return chordTones
    }
    
    public func notes(root : Note) -> [Note] {
        var notes = [Note](repeating: root, count: intervals.count)
        for i in 0..<notes.count {
            notes[i] = root.newNoteFromSteps(steps: intervals[i])
        }
        return notes
    }
}
