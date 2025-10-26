//
//  LogLevel.swift
//  SingerApp
//
//  Created on 2024.
//  Copyright © 2024 SingerApp. All rights reserved.
//

import Foundation
import OSLog

/// Log levels for different severity of messages
enum LogLevel: String, CaseIterable, Comparable {
    case verbose = "VERBOSE"
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
    
    /// OS Log type mapping
    var osLogType: OSLogType {
        switch self {
        case .verbose, .debug:
            return .debug
        case .info:
            return .info
        case .warning:
            return .default
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
    
    /// Emoji representation for console output
    var emoji: String {
        switch self {
        case .verbose: return "🔍"
        case .debug: return "🐛"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .critical: return "🚨"
        }
    }
    
    /// ANSI color code for terminal output
    var colorCode: String {
        switch self {
        case .verbose: return "\u{001B}[0;36m" // Cyan
        case .debug: return "\u{001B}[0;34m" // Blue
        case .info: return "\u{001B}[0;32m" // Green
        case .warning: return "\u{001B}[0;33m" // Yellow
        case .error: return "\u{001B}[0;31m" // Red
        case .critical: return "\u{001B}[0;35m" // Magenta
        }
    }
    
    var resetCode: String { "\u{001B}[0m" } // Reset
    
    /// Compare log levels for filtering
    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        let order: [LogLevel] = [.verbose, .debug, .info, .warning, .error, .critical]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
    
    /// Convert string to LogLevel
    static func from(_ string: String) -> LogLevel {
        switch string.lowercased() {
        case "verbose": return .verbose
        case "debug": return .debug
        case "info": return .info
        case "warning": return .warning
        case "error": return .error
        case "critical": return .critical
        default: return .info
        }
    }
}

/// LogEntry represents a single log entry with metadata
struct LogEntry {
    let level: LogLevel
    let message: String
    let category: String
    let file: String
    let function: String
    let line: Int
    let timestamp: Date
    let metadata: [String: Any]?
    
    init(level: LogLevel,
         message: String,
         category: String,
         file: String = #file,
         function: String = #function,
         line: Int = #line,
         metadata: [String: Any]? = nil) {
        self.level = level
        self.message = message
        self.category = category
        self.file = file
        self.function = function
        self.line = line
        self.timestamp = Date()
        self.metadata = metadata
    }
    
    /// Formatted output string
    var formattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: self.timestamp)
        
        let fileName = (file as NSString).lastPathComponent
        let metadataString = metadata?.map { "\($0.key): \($0.value)" }.joined(separator: ", ") ?? ""
        
        return "[\(timestamp)] \(level.emoji) \(level.rawValue) [\(category)] \(fileName):\(line) \(function) | \(message) \(metadataString.isEmpty ? "" : "| \(metadataString)")"
    }
}

