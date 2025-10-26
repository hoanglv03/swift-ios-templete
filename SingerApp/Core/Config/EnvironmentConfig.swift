//
//  EnvironmentConfig.swift
//  SingerApp
//
//  Created by Alexey Naumov.
//  Copyright © 2024 Alexey Naumov. All rights reserved.
//

import Foundation

// MARK: - Environment

enum AppEnvironment: String {
    case development
    case staging
    case production
    
    static var current: AppEnvironment {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
}

// MARK: - Environment Config

struct EnvironmentConfig {
    
    // MARK: - Singleton
    static let shared = EnvironmentConfig()
    
    private let env: AppEnvironment
    private var config: [String: String] = [:]
    
    private init() {
        self.env = AppEnvironment.current
        self.config = Self.loadConfig(for: env)
    }
    
    // MARK: - Load Configuration
    
    private static func loadConfig(for environment: AppEnvironment) -> [String: String] {
        // Try to load from .env file first
        if let envConfig = loadFromEnvFile(environment: environment) {
            return envConfig
        }
        
        // Fallback to Info.plist or default values
        return loadFromInfoPlist() ?? defaultConfig(for: environment)
    }
    
    private static func loadFromEnvFile(environment: AppEnvironment) -> [String: String]? {
        guard let bundlePath = Bundle.main.resourcePath else { return nil }
        let envFilename = "env.\(environment.rawValue)"
        let envPath = "\(bundlePath)/../\(envFilename)"
        let fileManager = FileManager.default
        
        // Try different paths
        let possiblePaths = [
            envPath,
            "\(bundlePath)/\(envFilename)",
            "\(fileManager.currentDirectoryPath)/config/\(envFilename)",
            "\(fileManager.currentDirectoryPath)/\(envFilename)"
        ]
        
        for path in possiblePaths {
            if let contents = try? String(contentsOfFile: path, encoding: .utf8) {
                return parseEnvFile(contents: contents)
            }
        }
        
        return nil
    }
    
    private static func parseEnvFile(contents: String) -> [String: String] {
        var config: [String: String] = [:]
        
        let lines = contents.components(separatedBy: .newlines)
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            // Skip comments and empty lines
            if trimmed.isEmpty || trimmed.hasPrefix("#") {
                continue
            }
            
            // Parse KEY=VALUE
            if let equalIndex = trimmed.firstIndex(of: "=") {
                let key = String(trimmed[..<equalIndex]).trimmingCharacters(in: .whitespaces)
                let value = String(trimmed[trimmed.index(after: equalIndex)...])
                    .trimmingCharacters(in: .whitespaces)
                    .trimmingCharacters(in: CharacterSet(charactersIn: "\"'"))
                
                config[key] = value
            }
        }
        
        return config
    }
    
    private static func loadFromInfoPlist() -> [String: String]? {
        guard let bundle = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let configDict = NSDictionary(contentsOfFile: bundle) as? [String: Any] else {
            return nil
        }
        
        var result: [String: String] = [:]
        for (key, value) in configDict {
            result[key] = "\(value)"
        }
        return result
    }
    
    private static func defaultConfig(for environment: AppEnvironment) -> [String: String] {
        switch environment {
        case .development:
            return [
                "API_BASE_URL": "https://restcountries.com/v2",
                "LOG_LEVEL": "debug",
                "ENABLE_ANALYTICS": "false"
            ]
        case .staging:
            return [
                "API_BASE_URL": "https://api.staging.countries.com",
                "LOG_LEVEL": "info",
                "ENABLE_ANALYTICS": "true"
            ]
        case .production:
            return [
                "API_BASE_URL": "https://restcountries.com/v2",
                "LOG_LEVEL": "error",
                "ENABLE_ANALYTICS": "true"
            ]
        }
    }
    
    // MARK: - Public Access
    
    func value(for key: String) -> String? {
        // First check CI/CD injected environment variables (for production)
        if let envValue = ProcessInfo.processInfo.environment[key], !envValue.isEmpty {
            return envValue
        }
        
        // Then check loaded .env file
        return config[key]
    }
    
    func boolValue(for key: String) -> Bool {
        guard let stringValue = value(for: key) else { return false }
        return stringValue.lowercased() == "true" || stringValue == "1"
    }
    
    func intValue(for key: String) -> Int? {
        guard let stringValue = value(for: key) else { return nil }
        return Int(stringValue)
    }
}

// MARK: - Configuration Keys

extension EnvironmentConfig {
    
    var apiBaseURL: String {
        value(for: "API_BASE_URL") ?? "https://restcountries.com/v2"
    }
    
    var apiTimeout: TimeInterval {
        Double(intValue(for: "API_TIMEOUT") ?? 30)
    }
    
    var logLevel: String {
        value(for: "LOG_LEVEL") ?? "debug"
    }
    
    var enableAnalytics: Bool {
        boolValue(for: "ENABLE_ANALYTICS")
    }
    
    var enableCrashReporting: Bool {
        boolValue(for: "ENABLE_CRASH_REPORTING")
    }
    
    var apiKey: String {
        value(for: "API_KEY") ?? ""
    }
    
    var apiSecret: String {
        value(for: "API_SECRET") ?? ""
    }
    
    var sentryDSN: String? {
        value(for: "SENTRY_DSN")
    }
}

