//
//  GridViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, GridViewDelegate {
    
    private let highOctave = 5
    private let notePattern : [(Int,Int)] = [(0,0),(2,0),(1,0),(0,1),(2,1),(1,1),(0,2),(2,2),(1,2),(3,2),(0,3),(2,3)]
    private let patternIndex : [Int] = [9,1,4,7,11,2,5,8,0,3,6,10]
    private var noteGrid : [[Note?]]?
    
    var midiHandler : MidiHandler?
    
    @IBOutlet var gridView: GridView! {
        didSet {
            gridView.gridDelegate = self
        }
    }
    
    private var key = Note(midiNote: 36) {
        didSet {
            gridView.updateColoring()
            gridView.updateGlow()
            gridView.updateHidingAndDisabling()
        }
    }
    
    var gridGap : CGFloat {
        return highlighting.gridGap
    }
    
    var highlighting = GridHighlighting.Roots {
        didSet {
            gridView.updateColoring()
            gridView.updateGlow()
            gridView.updateHidingAndDisabling()
        }
    }
    
    var buttonHidingOn = false {
        didSet {
            gridView.updateHidingAndDisabling()
        }
    }
    
    var buttonDisablingOn = false {
        didSet {
            gridView.updateHidingAndDisabling()
        }
    }
    
    var touchTrailsEnabled = false {
        didSet {
            gridView.touchIndicatorEnabled = touchTrailsEnabled
        }
    }
    
    func zoomIn() {
        currentScale = currentScale + scaleStep
    }
    
    func zoomOut() {
        currentScale = currentScale - scaleStep
    }
    
    func panLeft() {
        currentXTranslation = currentXTranslation + translateStep
    }
    
    func panRight() {
        currentXTranslation = currentXTranslation - translateStep
    }
    
    func panUp() {
        currentYTranslation = currentYTranslation + translateStep
    }
    
    func panDown() {
        currentYTranslation = currentYTranslation - translateStep
    }
    
    func changeKey(toKey : Note) {
        key = toKey
        gridView.updateColoring()
        gridView.updateGlow()
    }
    
    // assumes value between 0 and 10
    func gridZoom(scaleFactor : Double) {
        if scaleFactor < 0 || scaleFactor > 9 {
            return
        }
        gridView.hexWidth = CGFloat(100 + scaleFactor*15)
    }
    
    
    func reGlowChords() {
        gridView.updateGlow()
    }
    
    /// Seems to be way too many calls to this --> Think about improving efficiency here
    /// Store these instead
    func noteForGridLocation(row : Int, col : Int) -> Note {
        
        if noteGrid == nil || noteGrid?.count != gridView.numRows || noteGrid?[0].count != gridView.numCols {
            // print("recalculate grid notes")
            let numRows = gridView.numRows
            let numCols = gridView.numCols
            noteGrid = [[Note?]](repeating: [Note?](repeating: nil, count: numCols), count: numRows)
        }
        
        if noteGrid![row][col] == nil {
            noteGrid![row][col] = calculateNoteForGridLocation(row: row, col: col)
        }
        
        return noteGrid![row][col]!
    }
    
    func calculateNoteForGridLocation(row : Int, col : Int) -> Note {
        let toAdd = (-7*row/2)%12
        var rawNote = (toAdd+col)%12
        if rawNote < 0 {
            rawNote += 12
        }
        let octave = octaveForLocation(row: row, col : col, note : rawNote)
        let midiNote = octave*12 + rawNote
        let finalNote = Note(midiNote: midiNote)
        return finalNote
    }
    
    func titleForGridLocation(row : Int, col : Int) -> String {
        let note = noteForGridLocation(row: row, col: col)
        return note.description
        // return "\(row), \(col)"
    }
    
    func buttonColoring(row: Int, col: Int) -> HexButton.HexButtonColorState {
        let note = noteForGridLocation(row: row, col: col)
        let relativeInterval = (note.midiNote-(key.midiNote%12))%12
        if relativeInterval == 0 {
            return HexButton.HexButtonColorState.root
        }
        switch highlighting {
        case .Scales(let scale):
            if !scale.inScale(note: relativeInterval) {
                return HexButton.HexButtonColorState.outOfScale
            }
        default:
            break
        }
        return HexButton.HexButtonColorState.normal
    }
    
    func isButtonGlowing(row : Int, col : Int) -> Bool {
        switch highlighting {
        case .Chords(progression: _):
            let note = noteForGridLocation(row: row, col: col)
            if let h = midiHandler {
                return h.isChordTone(note: note)
            }
        default: break
        }
        return false
    }
    
    func isButtonHidden(row: Int, col: Int) -> Bool {
        let note = noteForGridLocation(row: row, col: col)
        let relativeInterval = (note.midiNote-(key.midiNote%12))%12
        switch highlighting {
        case .Scales(let scale):
            if !scale.inScale(note: relativeInterval) {
                return true
            }
        default: break
        }
        return false
    }
    
    func buttonRelease(row: Int, col: Int) {
        let note = noteForGridLocation(row: row, col: col)
        if let h = midiHandler {
            h.noteOff(note: note)
        }
    }
    
    func buttonPress(row: Int, col : Int, velocity: Int) {
        let note = noteForGridLocation(row: row, col: col)
        if let h = midiHandler {
            h.noteOn(note: note, velocity: velocity)
        }
    }
    
    func buttonVebrato(row : Int, col: Int, value : Int) {
        let note = noteForGridLocation(row: row, col: col)
        if let h = midiHandler {
            h.aftertouch(note: note, value: value)
        }
    }
    
    private func octaveForLocation(row : Int, col : Int, note : Int) -> Int {
        
        let patternPosition = notePattern[patternIndex[note]]
        _ = col - patternPosition.1
        let originRow = row - patternPosition.0
        
        var octave = highOctave
        
        if originRow > 0 && originRow < 4 {
            octave -= 1
        } else if originRow >= 4 && originRow < 8 {
            octave -= 2
        } else if originRow >= 8 && originRow < 11 {
            octave -= 3
        } else if originRow >= 11 && originRow < 14 {
            octave -= 4
        } else if originRow >= 14 && originRow < 17 {
            octave -= 5
        } else if originRow >= 17 && originRow < 20 {
            octave -= 6
        } else if originRow >= 20 && originRow < 22 {
            octave -= 7
        } else if originRow >= 22 {
            octave = 0
        }
        octave = max(octave, 0)
        return octave
        
    }
    
    
    ////////////////////////////////////
    /// Panning + Zooming Transforms ///
    ////////////////////////////////////
    
    
    private let scaleStep = CGFloat(0.1)
    private let translateStep = CGFloat(50)
    private let minScale = CGFloat(1.0)
    private let maxScale = CGFloat(2.0)
    private let minXTranslation = CGFloat(-200)
    private let maxXTranslation = CGFloat(200)
    private let minYTranslation = CGFloat(-200)
    private let maxYTranslation = CGFloat(200)
    
    private func animateTransform() {
        if let t = viewTransforms {
            // UIView.animateWithDuration(0.2, animations: {self.gridView.transform = t})
            gridView.transform = t
        }
    }
    private var viewTransforms : CGAffineTransform? {
        if let s = scaleTransform, let t = translateTransform {
            return s.concatenating(t)
        }
        if let t = translateTransform { return t }
        if let s = scaleTransform { return s }
        return nil
    }
    private var scaleTransform : CGAffineTransform? { didSet { animateTransform() } }
    private var translateTransform : CGAffineTransform? { didSet { animateTransform() } }
    
    private var currentScale = CGFloat(1.0) {
        didSet {
            if currentScale > maxScale {
                currentScale = maxScale
                return
            } else if currentScale < minScale {
                currentScale = minScale
                return
            }
            scaleTransform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        }
    }
    
    private var currentXTranslation = CGFloat(0.0) {
        didSet {
            if currentXTranslation > maxXTranslation {
                currentXTranslation = maxXTranslation
                return
            } else if currentXTranslation < minXTranslation {
                currentXTranslation = minXTranslation
                return
            }
            translateTransform = CGAffineTransform(translationX: currentXTranslation * 1.5*(currentScale-1), y: currentYTranslation * 1.5*(currentScale-1))
        }
    }
    
    private var currentYTranslation = CGFloat(0.0) {
        didSet {
            if currentYTranslation > maxYTranslation {
                currentYTranslation = maxYTranslation
                return
            } else if currentYTranslation < minYTranslation {
                currentYTranslation = minYTranslation
                return
            }
            translateTransform = CGAffineTransform(translationX: currentXTranslation * 1.5*(currentScale-1), y: currentYTranslation * 1.5*(currentScale-1))
        }
    }
    
}


