//
//  Logger.swift
//  Honeychord
//
//  Created by BrianBolze on 12/28/17.
//  Copyright © 2017 Bolze, LLC. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case debug
    case info
    case warning
    case error
    case none
    
    var logString: String {
        switch self {
        case .debug:
            return "▫️[D] "
        case .info:
            return "🔹[I] "
        case .warning:
            return "🔸[WARNING] "
        case .error:
            return "🔴[ERROR] "
        case .none:
            return ""
        }
    }
    
}

protocol Logger {
    
    static var logLevel: LogLevel { get set }
    static var logHeader: String { get set }
    
    static func isEnabled(level: LogLevel) -> Bool
    
    static func logDebug(_ message: CustomStringConvertible, function: String, file: String)
    static func logInfo(_ message: CustomStringConvertible, function: String, file: String)
    static func logWarn(_ message: CustomStringConvertible, function: String, file: String)
    static func logError(_ message: CustomStringConvertible, function: String, file: String)
    static func logDebug(_ message: String?, function: String, file: String)
    static func logInfo(_ message: String?, function: String, file: String)
    static func logWarn(_ message: String?, function: String, file: String)
    static func logError(_ message: String?, function: String, file: String)
    static func log(level: LogLevel, message: String?, function: String, file: String)
    
}

extension Logger {
    
    static func isEnabled(level: LogLevel) -> Bool {
        return level.rawValue >= self.logLevel.rawValue
    }
    
    static func logDebug(_ message: CustomStringConvertible, function: String = #function, file: String = #file) {
        guard isEnabled(level: .debug) else {
            return
        }
        log(level: .debug, message: message.description, function: function, file: file)
    }
    
    static func logInfo(_ message: CustomStringConvertible, function: String = #function, file: String = #file) {
        guard isEnabled(level: .info) else {
            return
        }
        log(level: .info, message: message.description, function: function, file: file)
    }
    
    static func logWarn(_ message: CustomStringConvertible, function: String = #function, file: String = #file) {
        guard isEnabled(level: .warning) else {
            return
        }
        log(level: .warning, message: message.description, function: function, file: file)
    }
    
    static func logError(_ message: CustomStringConvertible, function: String = #function, file: String = #file) {
        guard isEnabled(level: .error) else {
            return
        }
        log(level: .error, message: message.description, function: function, file: file)
    }
    
    static func logDebug(_ message: String? = nil, function: String = #function, file: String = #file) {
        guard isEnabled(level: .debug) else {
            return
        }
        log(level: .debug, message: message, function: function, file: file)
    }
    
    static func logInfo(_ message: String? = nil, function: String = #function, file: String = #file) {
        guard isEnabled(level: .info) else {
            return
        }
        log(level: .info, message: message, function: function, file: file)
    }
    
    static func logWarn(_ message: String? = nil, function: String = #function, file: String = #file) {
        guard isEnabled(level: .warning) else {
            return
        }
        log(level: .warning, message: message, function: function, file: file)
    }
    
    static func logError(_ message: String? = nil, function: String = #function, file: String = #file) {
        guard isEnabled(level: .error) else {
            return
        }
        log(level: .error, message: message, function: function, file: file)
    }
    
    static func log(level: LogLevel, message: String? = nil, function: String = #function, file: String = #file) {
        LogQueue.queue.async {
            
            var fileString = file.components(separatedBy: "/").last ?? ""
            fileString = fileString.components(separatedBy: ".").first ?? ""
            let errorString: String
            if let message = message {
                errorString = self.logHeader + level.logString + " \(fileString) -- \(function): \(message)"
            } else {
                errorString = self.logHeader + level.logString + " \(fileString) -- \(function)"
            }
            print(errorString)
        }
    }
    
}

enum LogQueue {
    static let queue = DispatchQueue(label: "Logger", qos: DispatchQoS.utility)
}

final class DebugLogger: Logger {
    static var logLevel = LogLevel.debug
    static var logHeader = "[DebugLogger] "
}

final class MIDILogger: Logger {
    static var logLevel = LogLevel.info
    static var logHeader = "[MIDI] "
}
