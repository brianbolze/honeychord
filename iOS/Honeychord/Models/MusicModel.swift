//
//  MusicModel.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

protocol MusicModelListener {
    func chordProgressionPositionAdvanced()
}

class MusicModel {
    
    let midiController = MidiController.sharedInstance
    var listener : MusicModelListener?
    
    let volumeControl = UInt8(7)
    let middleC = Note(midiNote: 24)
    var octave : Int {
        return (rootNote-24)/12
    }
    var rootNote : Int = 24
    var key = Note(midiNote: 24)
    var progressionPosition : Int = 0
    var chordProgression = ChordProgression.I_IV_V_I {
        didSet {
            progressionPosition = 0
        }
    }
    var inChordProgressionMode = false
    var scale = Scale.Major
    var velocityDown : Int = 120
    var velocityUp : Int = 40
    var currentNotesOn = [Int]()
    
    func isChordTone(note : Note) -> Bool {
        let root = key.midiNote + chordProgression.intervals[progressionPosition]
        let chord = chordProgression.chords[progressionPosition]
        return chord.isChordTone(note: note, withRoot: Note(midiNote: root))
    }
    
    func octaveUp() {
        rootNote = min(96, rootNote+12)
    }
    
    func octaveDown() {
        rootNote = max(0, rootNote-12)
    }
    
    func noteOn(note : Note, channel : Int) {
        midiController.noteOn(note: UInt8(rootNote + note.midiNote), velocity: UInt8(velocityDown), channelNum: UInt8(channel))
        currentNotesOn.append(note.midiNote)
        if inChordProgressionMode {
            if chordIsComplete() {
                advanceInChordProgression()
            }
        }
    }
    
    func noteOn(note : Note, velocity: Int, channelNum: Int) {
        midiController.noteOn(note: UInt8(rootNote + note.midiNote), velocity: UInt8(velocity), channelNum: UInt8(channelNum))
        currentNotesOn.append(note.midiNote)
        if inChordProgressionMode {
            if chordIsComplete() {
                advanceInChordProgression()
            }
        }
    }
    
    func noteOff(note : Note, channel : Int) {
        midiController.noteOff(note: UInt8(rootNote + note.midiNote), velocity: UInt8(velocityUp), channelNum: UInt8(channel))
        if let index = currentNotesOn.index(of: note.midiNote) {
            currentNotesOn.remove(at: index)
        }
    }
    
    func aftertouch(note: Note, value : Int, channel : Int) {
        if value < 0 || value > 127 {
            return
        }
        midiController.aftertouch(note: UInt8(rootNote + note.midiNote), value : UInt8(value), channelNum : UInt8(channel))
    }
    
    func pitchBend(value : Int, channel : Int) {
        if value < 0 || value > 127 {
            return
        }
        let val = UInt16((8192*value)/64)
        midiController.pitchBend(value: val, channelNum: UInt8(channel))
    }
    
    func volumeChange(value : Int) {
        if value < 0 || value > 127 {
            return
        }
        midiController.volumeChange(value: UInt8(value))
    }
    
    func controlChange(value : Int, control : Int, channel : Int) {
        if control < 0 || control > 127 || channel < 0 || channel > 16 || value < 0 || value > 127 {
            return
        }
        midiController.controlChange(ctrlNum: UInt8(control), value: UInt8(value), channelNum: UInt8(channel))
    }
    
    private func currentChordNotes() -> [Int] {
        let root = key.midiNote + chordProgression.intervals[progressionPosition]
        let chord = chordProgression.chords[progressionPosition]
        let notes = chord.notes(root: Note(midiNote: root))
        var intervals = [Int]()
        for n in notes {
            intervals.append(n.midiNote)
        }
        return intervals
    }
    
    private func advanceInChordProgression() {
        if progressionPosition+1 >= chordProgression.intervals.count {
            progressionPosition = 0
        } else {
            progressionPosition += 1
        }
        if let l = listener {
            l.chordProgressionPositionAdvanced()
        }
    }
    
    private func chordIsComplete() -> Bool {
        let basicCurrentNotes = currentNotesOn.map({$0%12})
        let basicChordNotes = currentChordNotes().map({$0%12})
        var notesOn = 0
        for n in 0..<basicChordNotes.count {
            if let _ = basicCurrentNotes.index(of: basicChordNotes[n]) {
                notesOn += 1
            }
        }
        return notesOn == basicChordNotes.count
    }
    
}
