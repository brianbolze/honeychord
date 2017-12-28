//
//  InstrumentChangeViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

class InstrumentChangeViewController: UIViewController {
    
    var changeHandler : SettingsChangeHandler?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        fixIOS9PopOverAnchor(segue: segue)
        if let id = segue.identifier {
            switch id {
            case "midiSharingModalSegue":
                DebugLogger.logInfo(MidiController.sharedInstance.getNumberOfMidiDevices())
            default:
                break
            }
        }
    }
    
    @IBAction func selectPiano() {
        changeHandler?.changeInstrument(toInstrument: .GrandPiano)
        dismissMe()
    }
    
    @IBAction func selectRhodes() {
        changeHandler?.changeInstrument(toInstrument: .Rhodes)
        dismissMe()
    }
    
    @IBAction func selectOrgan() {
        changeHandler?.changeInstrument(toInstrument: .Organ)
        dismissMe()
    }
    
    @IBAction func selectSynth() {
        changeHandler?.changeInstrument(toInstrument: .BigPad)
        dismissMe()
    }
    
    private func dismissMe() {
        dismiss(animated: true, completion: nil)
    }
    
}

