//
//  Constants.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

/// Statically defined constants shared across the app
enum App {
    
    
    
}

/// Statically shared flags for configuration of different modes and settings
enum Flags {
    
    
    // MARK: - Dev
    
    /// Whether the current device is an XCode simulated device
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
    
    /// Whether the current process is running unit tests
    static var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
}
