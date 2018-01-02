//
//  MIDIBusViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

protocol MIDIBusSettingsHandler {
    func knobState(knobID : Int) -> Bool
    func assignKnobControl(knobID : Int, control : MIDIControl)
    func assignKnobChannel(knobID : Int, channelNum : Int)
    func toggleKnob(knobID : Int) -> Bool
}

class MIDIBusViewController: UIViewController, MIDIBusSettingsHandler {
    
    var changeHandler : MidiHandler?
    
    private var knobStates = [true, true, true, true, true, false]
    private var knobChannels = [1,1,1,1,1,1]
    private var knobControls : [MIDIControl] =
        [.ctrl_1, .ctrl_10, .ctrl_21, .ctrl_22, .ctrl_23, .ctrl_76]  // Need good initial values here
    
    
    @IBOutlet weak var motionOnOffSwitch: SwitchButton!
    //    @IBOutlet weak var knob0button: UIButton! /// Modulation Knob
    //    @IBOutlet weak var knob1Button: UIButton! /// Pitch Bend Knob
    @IBOutlet weak var knob2Button: UIButton! /// Gyro X
    @IBOutlet weak var knob3button: UIButton! /// Gyro Y
    @IBOutlet weak var knob4button: UIButton! /// Gyro Z
    @IBOutlet weak var knob5button: UIButton! /// Vebrato
    private var knobs : [UIButton] {
        return [UIButton(), UIButton(), knob2Button, knob3button, knob4button, knob5button]
    }
    
    @IBOutlet weak var gyroXSlider: CustomSlider!
    @IBOutlet weak var gyroYSlider: CustomSlider!
    @IBOutlet weak var gyroZSlider: CustomSlider!
    @IBOutlet weak var vebratoSlider: CustomSlider!
    
    var modulationKnobValue = CGFloat(0.5)
    var pitchBendKnobValue = CGFloat(0.5)
    var gyroXValue = CGFloat(0.5) { didSet { gyroXSlider.value = gyroXValue; controlChange(knob: 2) } }
    var gyroYValue = CGFloat(0.5) { didSet { gyroYSlider.value = gyroYValue; controlChange(knob: 3) } }
    var gyroZValue = CGFloat(0.5) { didSet { gyroZSlider.value = gyroZValue; controlChange(knob: 4) } }
    var vebratoValue = CGFloat(0.5) { didSet { vebratoSlider.value = vebratoValue; controlChange(knob: 5)} }
    private var knobMIDIValues : [Int] {
        return [Int(127*modulationKnobValue), Int(127*pitchBendKnobValue),
                Int(127*gyroXValue), Int(127*gyroYValue), Int(127*gyroZValue), Int(127*vebratoValue)]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        fixIOS9PopOverAnchor(segue: segue)
        if let identifier = segue.identifier {
            switch identifier {
            case "knob1SendSegue":
                if let vc = segue.destination as? MIDIControlTableViewController {
                    vc.busHandler = self
                    vc.controlKnob = 0
                }
            case "knob2SendSegue":
                if let vc = segue.destination as? MIDIControlTableViewController {
                    vc.busHandler = self
                    vc.controlKnob = 1
                }
            case "gyroXSendSegue":
                if let vc = segue.destination as? MIDIControlTableViewController {
                    vc.busHandler = self
                    vc.controlKnob = 2
                }
            case "gyroYSendSegue":
                if let vc = segue.destination as? MIDIControlTableViewController {
                    vc.busHandler = self
                    vc.controlKnob = 3
                }
            case "gyroZSendSegue":
                if let vc = segue.destination as? MIDIControlTableViewController {
                    vc.busHandler = self
                    vc.controlKnob = 4
                }
            case "vebratoSendSegue":
                if let vc = segue.destination as? MIDIControlTableViewController {
                    vc.busHandler = self
                    vc.controlKnob = 5
                }
            default:
                break
            }
        }
    }
    
    
    @IBAction func zeroX() {
        changeHandler?.zeroY()
    }
    
    @IBAction func zeroY() {
        changeHandler?.zeroX()
    }
    
    @IBAction func zeroZ() {
        changeHandler?.zeroZ()
    }
    
    @IBAction func motionOnOff(sender: SwitchButton) {
        changeHandler?.motionToggle(on: !sender.on)
    }
    
    func knobState(knobID : Int) -> Bool {
        return knobStates[knobID]
    }
    
    func toggleKnob(knobID : Int) -> Bool {
        knobStates[knobID] = !knobStates[knobID]
        updateKnobLabel(knobID: knobID)
        return knobStates[knobID]
    }
    
    func assignKnobControl(knobID : Int, control : MIDIControl) {
        knobControls[knobID] = control
        updateKnobLabel(knobID: knobID)
    }
    
    func assignKnobChannel(knobID: Int, channelNum: Int) {
        knobChannels[knobID] = channelNum
    }
    
    func updateKnobLabel(knobID id: Int) {
        if knobStates[id] {
            knobs[id].setTitle(knobControls[id].shortDescription, for: .normal)
        } else {
            knobs[id].setTitle("Off", for: .normal)
        }
    }
    
    @IBAction func modulationKnobChange(sender: ModulatorKnob) {
        if knobStates[0] {
            modulationKnobValue = sender.value
            changeHandler?.ctrlChange(value: knobMIDIValues[0], ctrl: knobControls[0].rawValue, channel: knobChannels[0])
            // print("Control Change - \(knobControls[0]) -> \(knobMIDIValues[0])")
        }
    }
    
    @IBAction func pitchKnobChange(sender: PitchKnob) {
        if knobStates[1] {
            pitchBendKnobValue = sender.value
            changeHandler?.pitchBend(value: knobMIDIValues[1], channel: knobChannels[1])
            // print("Control Change - \(knobControls[1]) -> \(knobMIDIValues[1])")
        }
    }
    
    
    private func controlChange(knob : Int) {
        if knobStates[knob] {
            changeHandler?.ctrlChange(value: knobMIDIValues[knob], ctrl: knobControls[knob].rawValue, channel: knobChannels[knob])
            // print("changing: \(knobControls[knob]) to \(knobMIDIValues[knob]))")
        }
    }
    
}

