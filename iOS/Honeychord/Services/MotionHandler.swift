//
//  MotionHandler.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import Foundation
import CoreMotion

class MotionHandler {
    
    var changeHandler : SettingsChangeHandler?
    
    private let motionManager = CMMotionManager()
    private let updateInterval = TimeInterval(0.05)
    private let operationQueue = OperationQueue.main
    
    private var yaw = Double(0.5) { didSet { changeHandler?.changeYaw(toValue: yaw) } }
    private var pitch = Double(0.5) { didSet { changeHandler?.changePitch(toValue: pitch) } }
    private var roll = Double(0.5) { didSet { changeHandler?.changeRoll(toValue: roll) } }
    
    private var zeroXVal = Double(0.5)
    private var zeroYVal = Double(0.5)
    private var zeroZVal = Double(0.5)
    
    init() {
        motionManager.deviceMotionUpdateInterval = updateInterval
    }
    
    func startReading() {
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: operationQueue) { (data, error) in
            self.doStuff()
        }
    }
    
    func stopReading() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func zeroX() {
        if let motion = motionManager.deviceMotion {
            zeroXVal = motion.attitude.yaw
        }
        
    }
    
    func zeroY() {
        if let motion = motionManager.deviceMotion {
            zeroYVal = motion.attitude.pitch
        }
    }
    
    func zeroZ() {
        if let motion = motionManager.deviceMotion {
            zeroZVal = motion.attitude.roll
        }
    }
    
    private func doStuff() {
        if motionManager.isDeviceMotionActive {
            yaw   =  0.5*motionManager.deviceMotion!.attitude.yaw + zeroXVal
            pitch =  0.5*motionManager.deviceMotion!.attitude.pitch + zeroYVal
            roll  =  -0.5*motionManager.deviceMotion!.attitude.roll + zeroZVal
        }
    }
    
}
