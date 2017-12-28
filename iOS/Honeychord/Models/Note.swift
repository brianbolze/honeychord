//
//  Note.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public struct Note {
    
    public var midiNote : Int
    
    public func newNoteFromSteps(steps : Int) -> Note {
        return Note(midiNote: midiNote + steps)
    }
    
    public func toStringWithOctave() -> String {
        let octave = midiNote/12 - 2
        return Note.noteMap[midiNote%12] + "\(octave)"
    }
    
    public func interval(inKey : Note) -> String {
        let key = inKey.midiNote % 12
        let note = midiNote % 12
        var intervalNum = note-key
        if intervalNum < 0 {
            intervalNum += 12
        }
        return Note.intervalMap[intervalNum]
    }
    
    // MARK: - Private
    private static let noteMap : [String] = ["C","D♭","D","E♭","E","F","F#","G","A♭","A","B♭","B"]
    private static let intervalMap : [String] = ["1","2b","2","3b","3","4","4#,5b","5","5#,6b","6","7b","7"]
    
}


// MARK: - CustomStringConvertible

extension Note: CustomStringConvertible {
    public var description: String {
        return Note.noteMap[midiNote%12]
    }
}
