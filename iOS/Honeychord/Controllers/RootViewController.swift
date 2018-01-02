//
//  RootViewController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import UIKit
import MediaPlayer

protocol MidiHandler {
    func noteOn(note : Note)
    func noteOn(note : Note, velocity : Int)
    func noteOff(note : Note)
    func aftertouch(note : Note, value : Int)
    func pitchBend(value : Int, channel : Int)
    func ctrlChange(value : Int, ctrl : Int, channel : Int)
    func volumeChange(value : Int)
    func isChordTone(note : Note) -> Bool
    func motionToggle(on : Bool)
    func zeroX()
    func zeroY()
    func zeroZ()
}
class RootViewController: UIViewController, MidiHandler, SettingsChangeHandler, MusicModelListener, DraggableMenuDelegate {
    
    var services: AppServices!
    
    private var musicModel = MusicModel()
    private var midiController = MidiController.sharedInstance
    private var motionHandler = MotionHandler()
    private weak var gridVC : GridViewController?
    private var midiBus : MIDIBusViewController?
    
    private let sideBarExpandImageName = "side-bar-expand"
    private let sideBarCollapseImageName = "side-bar-collapse"
    
    @IBOutlet weak var volumeSlider: DraggableHorizontalSlider! {
        didSet {
            volumeSlider.value = CGFloat(AVAudioSession.sharedInstance().outputVolume)
        }
    }
    @IBOutlet weak var instrumentButton: UIButton!
    @IBOutlet weak var keyButton: UIButton!
    @IBOutlet weak var highlightingDropDown: UIButton! {
        didSet {
            highlightingDropDown.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var highlightingButtonBackground: UIImageView!
    
    @IBOutlet weak var sideBarButton: UIButton!
    @IBOutlet weak var sideBar: UIView!
    @IBOutlet weak var sideBarXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topBarLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBarContainer: UIView!
    @IBOutlet weak var topBarButton: VerticallyDraggableMenu! {
        didSet {
            topBarButton.panelDelegate = self
        }
    }
    
    var panel : UIView? {
        return topBarContainer
    }
    var panelConstraint : NSLayoutConstraint? {
        return topBarLayoutConstraint
    }
    /// To-do: Need to make this view-responsive
    var translateDistance : CGFloat {
        return 240
    }
    /// To-do: Need to make this view-responsive
    var translateTresholdDistance : CGFloat {
        return 50
    }
    
    var scaleHiding = false {
        didSet {
            gridVC?.buttonHidingOn = scaleHiding
        }
    }
    
    var scaleDisabling = false {
        didSet {
            gridVC?.buttonDisablingOn = scaleDisabling
        }
    }
    
    var touchTrailsEnabled = false {
        didSet {
            gridVC?.touchTrailsEnabled = touchTrailsEnabled
        }
    }
    var isInternalInstrumentActive = true {
        didSet {
            MidiController.sharedInstance.isInternalInstrumentActive = isInternalInstrumentActive
            updateInstrumentButton()
        }
    }
    var isVirtualMidiActive : Bool = false {
        didSet {
            MidiController.sharedInstance.isVirtualMidiActive = isVirtualMidiActive
            updateInstrumentButton()
        }
    }
    var isNetworkMidiActive : Bool = false {
        didSet {
            MidiController.sharedInstance.isNetworkMidiActive = isNetworkMidiActive
            updateInstrumentButton()
        }
    }
    
    private var sideBarExpandImage : UIImage? {
        return UIImage(named: sideBarExpandImageName)
    }
    
    private var sideBarCollapseImage : UIImage? {
        return UIImage(named: sideBarCollapseImageName)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        fixIOS9PopOverAnchor(segue: segue)
        if let identifier = segue.identifier {
            switch identifier {
            case "gridEmbedSegue":
                if let vc = segue.destination as? GridViewController {
                    gridVC = vc
                    vc.midiHandler = self
                }
            case "sideBarEmbedSegue":
                if let vc = segue.destination as? SideBarViewController {
                    vc.changeHandler = self
                }
            case "midiBusEmbedSegue":
                if let vc = segue.destination as? MIDIBusViewController {
                    midiBus = vc
                    vc.changeHandler = self
                }
            case "keyChangePopoverSegue":
                if let vc = segue.destination as? KeyChangeViewController {
                    vc.changeHandler = self
                    vc.initialKey = musicModel.key.midiNote - 24
                }
            case "instrumentChangePopoverSegue":
                if let vc = segue.destination as? InstrumentChangeViewController {
                    vc.changeHandler = self
                }
            case "highlightingChangePopoverSegue":
                if let vc = segue.destination as? HighlightingViewController {
                    vc.changeHandler = self
                    if let highlighting = gridVC?.highlighting {
                        switch highlighting {
                        case .Scales(let scale):
                            vc.selectionMode = .Scales
                            vc.currentScale = scale
                        case .Chords(let progression):
                            vc.selectionMode = .ChordProgressions
                            vc.currentProgression = progression
                        default: break
                        }
                    }
                }
            case "settingsPopoverSegue":
                if let vc = segue.destination as? SettingsViewController {
                    vc.changeHandler = self
                }
            default: break
            }
        }
    }
    
    override func viewDidLoad() {
        musicModel.listener = self
        motionHandler.changeHandler = self
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let path = keyPath {
            switch path {
            case "outputVolume":
                let val = AVAudioSession.sharedInstance().outputVolume
                volumeSlider.value = CGFloat(val)
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func highlightingChange(sender: TripleSwitchButton) {
        switch sender.currentState {
        case 0:
            gridVC?.highlighting = .Scales(scale: musicModel.scale)
            highlightingDropDown.setTitle(musicModel.scale.name, for: .normal)
            highlightingDropDown.isHidden = false
            highlightingButtonBackground.isHidden = false
        case 1:
            gridVC?.highlighting = .Chords(progression: musicModel.chordProgression)
            musicModel.inChordProgressionMode = true
            highlightingDropDown.setTitle(musicModel.chordProgression.description, for: .normal)
            gridVC?.reGlowChords()
        case 2:
            gridVC?.highlighting = .Roots
            musicModel.inChordProgressionMode = false
            highlightingDropDown.isHidden = true
            highlightingButtonBackground.isHidden = true
        default: break
        }
    }
    
    @IBAction func sideBarToggle() {
        let animationDuration = TimeInterval(0.5)
        let xTranslateDist = sideBar.frame.width
        view.layoutIfNeeded()
        switch sideBarButton.tag {
        case 0:
            sideBarButton.tag = 1
            sideBarXConstraint.constant += xTranslateDist
            sideBarButton.setImage(sideBarExpandImage, for: .normal)
            UIView.animate(withDuration: animationDuration,
                                       animations: {self.view.layoutIfNeeded()})
        case 1:
            sideBarButton.tag = 0
            sideBarXConstraint.constant -= xTranslateDist
            sideBarButton.setImage(sideBarCollapseImage, for: .normal)
            UIView.animate(withDuration: animationDuration,
                                       animations: {self.view.layoutIfNeeded()})
        default:
            break
        }
        
    }
    
    @IBAction func volumeSliderValueChanged(sender: DraggableHorizontalSlider) {
        let val = Int(127*sender.value)
        volumeChange(value: val)
    }
    
    func chordProgressionPositionAdvanced() {
        gridVC?.reGlowChords()
    }
    
    func noteOff(note: Note) {
        musicModel.noteOff(note: note, channel: 1)
    }
    
    func noteOn(note: Note) {
        musicModel.noteOn(note: note, channel: 1)
    }
    
    func noteOn(note : Note, velocity : Int) {
        musicModel.noteOn(note: note, velocity: velocity, channelNum: 1)
    }
    
    func aftertouch(note : Note, value : Int) {
        musicModel.aftertouch(note: note, value: value, channel: 1)
    }
    
    func pitchBend(value : Int, channel : Int) {
        musicModel.pitchBend(value: value, channel: channel)
    }
    
    func ctrlChange(value : Int, ctrl : Int, channel : Int) {
        musicModel.controlChange(value: value, control: ctrl, channel: channel)
    }
    
    func volumeChange(value: Int) {
        musicModel.volumeChange(value: value)
    }
    
    func motionToggle(on: Bool) {
        if on {
            motionHandler.startReading()
        } else {
            motionHandler.stopReading()
            // resetControls()
        }
    }
    
    func zeroX() {
        motionHandler.zeroX()
    }
    
    func zeroY() {
        motionHandler.zeroY()
    }
    
    func zeroZ() {
        motionHandler.zeroZ()
    }
    
    func isChordTone(note : Note) -> Bool {
        return musicModel.isChordTone(note: note)
    }
    
    func changeInstrument(toInstrument: MIDIInstrument) {
        MidiController.sharedInstance.changeInstrument(toInstrument: toInstrument)
        updateInstrumentButton()
    }
    
    private func updateInstrumentButton() {
        let instrument = MidiController.sharedInstance.currentInstrument
        if MidiController.sharedInstance.isInternalInstrumentActive {
            instrumentButton.setTitle(instrument.description, for: .normal)
            instrumentButton.isEnabled = true
        } else if MidiController.sharedInstance.isVirtualMidiActive || MidiController.sharedInstance.isNetworkMidiActive {
            instrumentButton.setTitle("Virtual Midi", for: .normal)
            instrumentButton.isEnabled = false
        } else {
            instrumentButton.setTitle("Inactive", for: .normal)
            instrumentButton.isEnabled = false
        }
    }
    
    func changeKey(toKey: Int) {
        musicModel.key = musicModel.middleC.newNoteFromSteps(steps: toKey)
        keyButton.setTitle(musicModel.key.description, for: .normal)
        gridVC?.changeKey(toKey: musicModel.key)
    }
    
    func changeScale(toScale : Scale) {
        musicModel.scale = toScale
        highlightingDropDown.setTitle(toScale.name, for: .normal)
        gridVC?.highlighting = .Scales(scale: toScale)
    }
    
    func changeChordProgression(progression : ChordProgression) {
        musicModel.chordProgression = progression
        highlightingDropDown.setTitle(progression.description, for: .normal)
        gridVC?.highlighting = .Chords(progression: progression)
    }
    
    func zoomIn() {
        gridVC?.zoomIn()
    }
    func zoomOut(){
        gridVC?.zoomOut()
    }
    func panLeft(){
        gridVC?.panLeft()
    }
    func panRight(){
        gridVC?.panRight()
    }
    func panUp(){
        gridVC?.panUp()
    }
    func panDown(){
        gridVC?.panDown()
    }
    func changePitch(toValue : Double) {
        midiBus?.gyroXValue = CGFloat(toValue)
    }
    func changeYaw(toValue : Double) {
        midiBus?.gyroYValue = CGFloat(toValue)
    }
    func changeRoll(toValue : Double) {
        midiBus?.gyroZValue = CGFloat(toValue)
    }
    
    
}
