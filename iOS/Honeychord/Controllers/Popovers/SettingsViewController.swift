//
//  SettingsViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit

protocol SettingsChangeHandler {
    var touchTrailsEnabled : Bool { get set }
    var scaleHiding : Bool { get set }
    var scaleDisabling : Bool { get set }
    var isInternalInstrumentActive : Bool { get set }
    var isVirtualMidiActive : Bool { get set }
    var isNetworkMidiActive : Bool { get set }
    func changeInstrument(toInstrument : MIDIInstrument)
    func changeKey(toKey : Int)
    func changeScale(toScale : Scale)
    func changeChordProgression(progression : ChordProgression)
    func zoomIn()
    func zoomOut()
    func panLeft()
    func panRight()
    func panUp()
    func panDown()
    func changePitch(toValue : Double)
    func changeYaw(toValue : Double)
    func changeRoll(toValue : Double)
}

class SettingsViewController: UITableViewController {
    
    var changeHandler : SettingsChangeHandler?
    
    //    @IBOutlet weak var networkNameLabel: UILabel!
    //    @IBOutlet weak var numConnectionsLabel: UILabel!
    @IBOutlet weak var internalInstrumentSwitch: UISwitch! {
        didSet {
            internalInstrumentSwitch.isOn = changeHandler?.isInternalInstrumentActive ?? false
        }
    }
    @IBOutlet weak var virtualMidiSwitch: UISwitch! {
        didSet {
            virtualMidiSwitch.isOn = changeHandler?.isVirtualMidiActive ?? false
        }
    }
    @IBOutlet weak var networkStatusSwitch: UISwitch! {
        didSet {
            networkStatusSwitch.isOn = changeHandler?.isNetworkMidiActive ?? false
        }
    }
    @IBOutlet weak var outOfScaleHidingSwitch: UISwitch! {
        didSet {
            outOfScaleHidingSwitch.isOn = changeHandler?.scaleHiding ?? false // get this from masterVC
        }
    }
    @IBOutlet weak var outOfScaleDisablingSwitch: UISwitch! {
        didSet {
            outOfScaleDisablingSwitch.isOn = changeHandler?.scaleDisabling ?? false
        }
    }
    
    @IBOutlet weak var touchTrailsSwitch: UISwitch! {
        didSet {
            touchTrailsSwitch.isOn = changeHandler?.touchTrailsEnabled ?? false
        }
    }
    //
    //    @IBOutlet weak var gridSizeStepper: UIStepper! {
    //        didSet {
    //            gridSizeStepper.maximumValue = 10
    //            gridSizeStepper.minimumValue = 0
    //            gridSizeStepper.stepValue = 1
    //            gridSizeStepper.value = 5
    //            gridSizeStepper.wraps = false
    //        }
    //    }
    
    
    
    //    override func viewDidLoad() {
    //        updateNetworkSettings()
    //    }
    
    //    @IBAction func updateNetworkSettings() {
    //        networkNameLabel.text = midiController.getNetworkName()
    //        numConnectionsLabel.text = midiController.getNumberOfNetworkConnections()
    //    }
    
    
    @IBAction func internalInstrumentToggle(sender: UISwitch) {
        changeHandler?.isInternalInstrumentActive = sender.isOn
    }
    
    
    @IBAction func virtualMidiToggle(sender: UISwitch) {
        changeHandler?.isVirtualMidiActive = sender.isOn
    }
    
    @IBAction func networkEnableChange(sender: UISwitch) {
        changeHandler?.isNetworkMidiActive = sender.isOn
    }
    
    @IBAction func outOfScaleHidingChange(sender: UISwitch) {
        changeHandler?.scaleHiding = sender.isOn
    }
    
    @IBAction func outOfScaleDisablingChange(sender: UISwitch) {
        changeHandler?.scaleDisabling = sender.isOn
    }
    
    @IBAction func touchTrailsChange(sender: UISwitch) {
        changeHandler?.touchTrailsEnabled = sender.isOn
    }
    
    
    //    @IBAction func gridSizeChange(sender: UIStepper) {
    //        if let h = changeHandler {
    //            h.gridZoom(sender.value)
    //        }
    //    }
    
}

