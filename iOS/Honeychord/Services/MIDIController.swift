//
//  MIDIController.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import AVFoundation
import MediaPlayer

class MidiController {
    
    // Singleton
    static let sharedInstance = MidiController()
    
    var isVirtualMidiActive : Bool {
        get {
            return virtualMidiOn
        }
        set {
            virtualMidiOn = newValue
            if newValue {
                setupVirtualMidi()
            } else {
                disableVirtualMidi()
            }
        }
    }
    var isNetworkMidiActive : Bool {
        get {
            return networkMidiOn
        }
        set {
            print(networkMidiOn)
            networkMidiOn = newValue
            if newValue {
                setupNetworkMidi()
            } else {
                disableNetworkMidi()
            }
        }
    }
    var isInternalInstrumentActive : Bool {
        get {
            return internalInstrumentOn
        }
        set {
            internalInstrumentOn = newValue
        }
    }
    
    private(set) var currentInstrument = MidiController.defaultMidiInstrument {
        didSet {
            loadInstrument(instrumentURL: soundbankURL, instrument: currentInstrument)
        }
    }
    
    func getNetworkName() -> String {
        return networkMidiOn ? virtualMidiNetworkSession!.networkName : "Inactive"
    }
    
    func getNumberOfNetworkConnections() -> String {
        let val = virtualMidiNetworkSession?.connections().count ?? 0
        return "\(val)"
    }
    
    func getNumberOfMidiDevices() -> String {
        return "\(MIDIGetNumberOfDevices())"
    }
    
    func noteOn(note: UInt8, velocity: UInt8, channelNum: UInt8) {
        if internalInstrumentOn {
            // Should break if internal instrument is on and this is nil
            audioSampler!.startNote(note, withVelocity: velocity, onChannel: channelNum)
        }
        if isVirtualMidiActive || isNetworkMidiActive {
            let status = statusBits(channelNum: channelNum, code: 0b10010000)
            let data = [status, note, velocity]
            sendVirtualMidiMessage(messageData: data)
        }
    }
    
    func noteOff(note: UInt8, velocity: UInt8, channelNum: UInt8) {
        if internalInstrumentOn {
            // Should break if internal instrument is on and this is nil
            audioSampler!.stopNote(note, onChannel: channelNum)
        }
        if isVirtualMidiActive || isNetworkMidiActive {
            let status = statusBits(channelNum: channelNum, code: 0b10000000)
            let data = [status, note, velocity]
            sendVirtualMidiMessage(messageData: data)
        }
    }
    
    func changeInstrument(toInstrument: MIDIInstrument) {
        currentInstrument = toInstrument
    }
    
    func aftertouch(note : UInt8, value : UInt8, channelNum : UInt8) {
        let status = statusBits(channelNum: channelNum, code: 0b10100000)
        let data = [status, note, value]
        if isInternalInstrumentActive {
            audioSampler?.sendPressure(forKey: note, withValue: value, onChannel: channelNum)
        }
        sendVirtualMidiMessage(messageData: data)
    }
    
    func pitchBend(value: UInt16, channelNum: UInt8?) {
        let status = statusBits(channelNum: channelNum, code: 0b11100000)
        let data_lsb = UInt8(0b01111111 & value)
        let data_msb = UInt8(0b01111111 & value >> 7)
        let data = [status, data_lsb, data_msb]
        if isInternalInstrumentActive {
            audioSampler?.sendPitchBend(value, onChannel: channelNum!)
        }
        sendVirtualMidiMessage(messageData: data)
    }
    
    func controlChange(ctrlNum : UInt8, value : UInt8, channelNum : UInt8?) {
        let status = statusBits(channelNum: channelNum, code: 0b10110000)
        let data = [status, ctrlNum, value]
        if isInternalInstrumentActive {
            audioSampler?.sendMIDIEvent(status, data1: ctrlNum, data2: value)
        }
        sendVirtualMidiMessage(messageData: data)
    }
    
    func volumeChange(value: UInt8) {
        let val = max(0.0, min(1.0, Float(value)/128.0))
        setSystemVolume(val)
    }
    
    
    private func setSystemVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        for view in volumeView.subviews {
            if (NSStringFromClass(view.classForCoder) == "MPVolumeSlider") {
                let slider = view as! UISlider
                slider.setValue(volume, animated: false)
            }
        }
    }
    
    
    
    private init() {
        
        virtualMidiOn = false
        networkMidiOn = false
        internalInstrumentOn = true
        
        audioSession = AVAudioSession.sharedInstance()
        
        activateAudioSession()
        
        if virtualMidiOn || networkMidiOn {
            setupVirtualMidi()
        }
        
        if networkMidiOn {
            setupNetworkMidi()
        }
        
        if internalInstrumentOn {
            audioEngine = AVAudioEngine()
            audioSampler = AVAudioUnitSampler()
            
            attachAudioSampler()
            startAudioEngine()
        }
        
        
        loadInstrument(instrumentURL: soundbankURL, instrument: MidiController.defaultMidiInstrument)
        
    }
    
    /// NOTE : Need to setup observers on these for setups
    private var virtualMidiOn : Bool
    private var networkMidiOn : Bool
    private var internalInstrumentOn : Bool
    private static let defaultMidiInstrument = MIDIInstrument.GrandPiano
    
    // Virtual Midi
    private var virtualMidiNetworkSession : MIDINetworkSession?
    private var virtualMidiClient : MIDIClientRef?
    private var virtualMidiSource : MIDIEndpointRef?
    private var virtualMidiOutputPort : MIDIPortRef?
    
    // Internal Instrument
    private let audioSession : AVAudioSession
    private var audioEngine : AVAudioEngine?
    private var audioSampler : AVAudioUnitSampler?
    private let soundbankURL = Bundle.main.url(forResource: "../Keyboards", withExtension: "sf2")
    
    
    private func loadInstrument(instrumentURL: URL?, instrument : MIDIInstrument) {
        let programNum = instrument.presetNumber
        if let url = instrumentURL {
            do {
                try audioSampler?.loadSoundBankInstrument(at: url, program: programNum, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                                               bankLSB: UInt8(kAUSampler_DefaultBankLSB))
            } catch {
                print("Error loading instrument")
            }
        }
    }
    
    private func activateAudioSession() {
        do {
            // try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
        } catch {
            print("Error setting Audio Session Category")
        }
        do {
            try audioSession.setActive(true)
        } catch {
            print("Error activating Audio Session")
        }
    }
    
    private func startAudioEngine() {
        if let engine = audioEngine {
            engine.prepare()
            do {
                try engine.start()
            } catch _ {
                print("Error starting Audio Engine")
            }
        }
    }
    
    private func attachAudioSampler() {
        if let sampler = audioSampler, let engine = audioEngine {
            engine.attach(sampler)
            engine.connect(sampler, to: engine.outputNode, format: nil)
        }
    }
    
    private func statusBits(channelNum : UInt8?, code : UInt8) -> UInt8 {
        var statusBits : UInt8 = code
        if let channel = channelNum {
            if channel < 16 {
                statusBits += channel
            }
        }
        return statusBits
    }
    
    private func sendVirtualMidiMessage(messageData : [UInt8]?) {
        
        var data = messageData ?? [144, 36, 5]
        
        var packetList = MIDIPacketList()
        var packet = MIDIPacketListInit(&packetList)
        packet = MIDIPacketListAdd(&packetList, 1024,
                                   packet, 0, 3, &data)
        
        if networkMidiOn {
            MIDISend(virtualMidiOutputPort!, virtualMidiNetworkSession!.destinationEndpoint(), &packetList)
        }
        if virtualMidiOn {
            MIDIReceived(virtualMidiSource!, &packetList)
        }
        
    }
    
    private func setupVirtualMidi() {
        virtualMidiClient = MIDIClientRef()
        virtualMidiSource = MIDIEndpointRef()
        virtualMidiOutputPort = MIDIPortRef()
        let name = Bundle.main.infoDictionary!["CFBundleName"] as? String
        
        let notifyBlock: MIDINotifyBlock = MyMIDINotifyBlock
        if #available(iOS 9.0, *) {
            print("here")
            MIDIClientCreateWithBlock(name! as CFString, &virtualMidiClient!, notifyBlock)
        } else {
            MIDIClientCreate(name! as CFString, nil, nil, &virtualMidiClient!)
        }
        
        
        // MIDIClientCreate(name!, nil, nil, &virtualMidiClient!)
        MIDISourceCreate(virtualMidiClient!, name! as CFString, &virtualMidiSource!)
        MIDIOutputPortCreate(virtualMidiClient!, "Output" as CFString, &virtualMidiOutputPort!)
        MIDIPortConnectSource(virtualMidiOutputPort!, virtualMidiSource!, nil)
    }
    
    private func disableVirtualMidi() {
        if !networkMidiOn && !virtualMidiOn {
            MIDIClientDispose(virtualMidiClient!)
            MIDIPortDispose(virtualMidiOutputPort!)
            MIDIEndpointDispose(virtualMidiSource!)
            virtualMidiClient = nil
            virtualMidiOutputPort = nil
            virtualMidiSource = nil
        }
    }
    
    private func setupNetworkMidi() {
        if virtualMidiClient == nil {
            setupVirtualMidi()
        }
        virtualMidiNetworkSession = MIDINetworkSession.default()
        virtualMidiNetworkSession!.isEnabled = true
        virtualMidiNetworkSession!.connectionPolicy = MIDINetworkConnectionPolicy.anyone
    }
    
    private func disableNetworkMidi() {
        // do nothing
    }
    
    func MyMIDINotifyBlock(midiNotification: UnsafePointer<MIDINotification>) {
        print("got a MIDINotification!")
        
        let notification = midiNotification.pointee
        print("MIDI Notify, messageId= \(notification.messageID)")
        print("MIDI Notify, messageSize= \(notification.messageSize)")
        
        // values are now an enum!
        
        switch (notification.messageID) {
        case .msgSetupChanged:
            print("MIDI setup changed")
            break
            
        //TODO: so how to "downcast" to MIDIObjectAddRemoveNotification
        case .msgObjectAdded:
            
            print("added")
            
            var mem = midiNotification.pointee
            withUnsafePointer(to: &mem) { ptr -> Void in
                let mp = unsafeBitCast(ptr, to: UnsafePointer<MIDIObjectAddRemoveNotification>.self)
                let m = mp.pointee
                print("id \(m.messageID)")
                print("size \(m.messageSize)")
                print("child \(m.child)")
                print("child type \(m.childType)")
                print("parent \(m.parent)")
                print("parentType \(m.parentType)")
            }
            
            break
            
        case .msgObjectRemoved:
            print("kMIDIMsgObjectRemoved")
            break
            
        case .msgPropertyChanged:
            print("kMIDIMsgPropertyChanged")
            
            var mem = midiNotification.pointee
            withUnsafePointer(to: &mem) { ptr -> Void in
                let mp = unsafeBitCast(ptr, to: UnsafePointer<MIDIObjectPropertyChangeNotification>.self)
                let m = mp.pointee
                print("id \(m.messageID)")
                print("size \(m.messageSize)")
                print("object \(m.object)")
                print("objectType  \(m.objectType)")
                
                //                if m.propertyName.takeUnretainedValue() == kMIDIPropertyOffline {
                //                    var value = Int32(0)
                //                    let status = MIDIObjectGetIntegerProperty(m.object, kMIDIPropertyOffline, &value)
                //                    if status != noErr {
                //                        print("oops")
                //                    }
                //                    print("The offline property is \(value)")
                //                }
                
            }
            
            break
            
        case .msgThruConnectionsChanged:
            print("MIDI thru connections changed.")
            break
            
        case .msgSerialPortOwnerChanged:
            print("MIDI serial port owner changed.")
            break
            
        case .msgIOError:
            print("MIDI I/O error.")
            //MIDIIOErrorNotification
            break
            
        }
        
    }
    
    
}
