//
//  UtilityServices.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

/// Utility class for performing background functions. Abstracted out of AppDelegate class to improve readability.
public final class UtilityServices {
    
    public init() {
        setupLogging()
    }
    
    
    // MARK: - Private
    
    /// Configure the output log levels of each component logger
    private func setupLogging() {
        if Flags.isRunningTests { return }
        
        DebugLogger.logLevel = .debug
        MIDILogger.logLevel = .debug
    }
    
}
