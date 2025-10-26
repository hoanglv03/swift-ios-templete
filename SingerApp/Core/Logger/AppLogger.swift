//
//  AppLogger.swift
//  SingerApp
//
//  Created on 2024.
//  Copyright © 2024 SingerApp. All rights reserved.
//

import Foundation
import OSLog

/// Main logging system for SingerApp
final class AppLogger {

    // MARK: - Singleton
    static let shared = AppLogger()

    // MARK: - Properties
    private let logQueue = DispatchQueue(label: "com.singerapp.logger", qos: .utility)
    private var minimumLevel: LogLevel = .debug
    private var enableColors: Bool = true

    // MARK: - Initialization

    private init() {}

    /// Configure logger with environment-specific settings
    func configure(
        minimumLevel: LogLevel? = nil,
        enableConsole: Bool? = nil,
        enableFile: Bool? = nil,
        enableRemote: Bool? = nil,
        sentryDSN: String? = nil
    ) {
        if let level = minimumLevel {
            self.minimumLevel = level
        }
    }

    // MARK: - Public Logging Methods

    func verbose(
        _ message: String, category: String = "App", metadata: [String: Any]? = nil,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .verbose, message: message, category: category, metadata: metadata, file: file,
            function: function, line: line)
    }

    func debug(
        _ message: String, category: String = "App", metadata: [String: Any]? = nil,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .debug, message: message, category: category, metadata: metadata, file: file,
            function: function, line: line)
    }

    func info(
        _ message: String, category: String = "App", metadata: [String: Any]? = nil,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .info, message: message, category: category, metadata: metadata, file: file,
            function: function, line: line)
    }

    func warning(
        _ message: String, category: String = "App", metadata: [String: Any]? = nil,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .warning, message: message, category: category, metadata: metadata, file: file,
            function: function, line: line)
    }

    func error(
        _ message: String, category: String = "App", metadata: [String: Any]? = nil,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .error, message: message, category: category, metadata: metadata, file: file,
            function: function, line: line)
    }

    func critical(
        _ message: String, category: String = "App", metadata: [String: Any]? = nil,
        file: String = #file, function: String = #function, line: Int = #line
    ) {
        log(
            level: .critical, message: message, category: category, metadata: metadata, file: file,
            function: function, line: line)
    }

    // MARK: - Core Logging

    private func log(
        level: LogLevel,
        message: String,
        category: String,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: Int
    ) {

        guard level >= minimumLevel else { return }

        let entry = LogEntry(
            level: level,
            message: message,
            category: category,
            file: file,
            function: function,
            line: line,
            metadata: metadata)

        logQueue.async { [weak self] in
            guard let self = self else { return }
            self.printEntry(entry)
        }
    }

    private func printEntry(_ entry: LogEntry) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: entry.timestamp)

        let fileName = (entry.file as NSString).lastPathComponent
        let functionName = entry.function.components(separatedBy: "(").first ?? entry.function

        if enableColors {
            let color = entry.level.colorCode
            let reset = entry.level.resetCode
            print(
                "\(color)\(timestamp) \(entry.level.emoji) [\(entry.category)] \(fileName):\(entry.line) | \(functionName) | \(entry.message)\(reset)"
            )
        } else {
            print(
                "[\(timestamp)] \(entry.level.emoji) \(entry.level.rawValue) [\(entry.category)] \(fileName):\(entry.line) | \(functionName) | \(entry.message)"
            )
        }

        // Print metadata if exists
        if let metadata = entry.metadata, !metadata.isEmpty {
            let metadataString = metadata.map { "  - \($0.key): \($0.value)" }.joined(
                separator: "\n")
            print(metadataString)
        }
    }

    // MARK: - Convenience Methods

    func logNetwork(_ message: String, url: String? = nil, method: String? = nil) {
        var metadata: [String: Any] = [:]
        if let url = url { metadata["url"] = url }
        if let method = method { metadata["method"] = method }
        info(message, category: "Network", metadata: metadata)
    }

    func logError(_ errorInfo: Error, context: String = "") {
        error(
            "\(context.isEmpty ? "" : "\(context): ")\(errorInfo.localizedDescription)",
            category: "Error",
            metadata: [
                "domain": (errorInfo as NSError).domain,
                "code": (errorInfo as NSError).code,
                "description": errorInfo.localizedDescription,
            ])
    }

    func logData(_ data: Data, description: String) {
        debug(
            "\(description): \(data.count) bytes", category: "Data", metadata: ["size": data.count])
    }
}

// MARK: - Global Helper

/// Global logger instance for easy access
let logger = AppLogger.shared
