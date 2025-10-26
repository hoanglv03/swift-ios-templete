# 📝 AppLogger - Logging System

Complete logging system for SingerApp with multiple destinations and environment-aware configuration.

## 🌟 Features

- ✅ **6 Log Levels**: Verbose, Debug, Info, Warning, Error, Critical
- ✅ **Multiple Destinations**: Console, File, Remote (Sentry)
- ✅ **Color-coded Output**: Beautiful console output with colors
- ✅ **Environment-aware**: Automatic configuration based on environment
- ✅ **Performance**: Async logging on background queue
- ✅ **File Rotation**: Automatic log file rotation
- ✅ **Error Tracking**: Integrated with Sentry for production

## 📖 Usage

### Basic Usage

```swift
import Foundation

// Get the global logger
let logger = AppLogger.shared

// Log at different levels
logger.verbose("Detailed debug information")
logger.debug("Debug message")
logger.info("Informational message")
logger.warning("Warning message")
logger.error("Error occurred")
logger.critical("Critical issue!")
```

### With Category

```swift
logger.info("User logged in", category: "Auth")
logger.debug("Loading countries", category: "Network")
logger.error("Database connection failed", category: "Database")
```

### With Metadata

```swift
logger.info("API request started", 
    category: "Network",
    metadata: [
        "url": "https://api.example.com/users",
        "method": "GET",
        "userId": user.id
    ])
```

### Convenience Methods

```swift
// Network logging
logger.logNetwork("API request successful", url: "https://api.com", method: "GET")

// Error logging with context
logger.logError(error, context: "Failed to load countries")

// Data logging
logger.logData(data, description: "Downloaded image")
```

## 🎨 Output Examples

### Console Output (with colors)

```
14:23:45.123 ℹ️ INFO [Network] WebRepository.swift:28 | countries() | Loading countries...
14:23:46.234 ✅ DEBUG [App] AppDelegate.swift:42 | applicationDidFinishLaunching | App launched successfully
14:23:47.345 ⚠️ WARNING [Database] ModelContainer.swift:15 | configure() | Using fallback database
14:23:48.456 ❌ ERROR [Network] WebRepository.swift:45 | call() | Network error: Connection timeout
14:23:49.567 🚨 CRITICAL [App] AppDelegate.swift:67 | crashHandler() | App crashed with exception!
```

### File Output

Logs are written to: `Documents/Logs/singerapp.log`

```
[2024-01-15 14:23:45.123] ℹ️ INFO [Network] WebRepository.swift:28 countries() | Loading countries...
[2024-01-15 14:23:46.234] ✅ DEBUG [App] AppDelegate.swift:42 applicationDidFinishLaunching | App launched successfully
```

## 🔧 Configuration

### Environment-based Configuration

Logger automatically configures based on environment:

**Development** (`config/env.development`):
```bash
LOG_LEVEL=debug
ENABLE_FILE_LOGGING=false
ENABLE_CONSOLE_LOGGING=true
```

**Staging** (`config/env.staging`):
```bash
LOG_LEVEL=info
ENABLE_FILE_LOGGING=true
ENABLE_CONSOLE_LOGGING=true
```

**Production** (`config/env.production`):
```bash
LOG_LEVEL=error
ENABLE_FILE_LOGGING=true
ENABLE_CONSOLE_LOGGING=false
ENABLE_CRASH_REPORTING=true
SENTRY_DSN=https://xxx@sentry.io/project
```

### Manual Configuration

```swift
AppLogger.shared.configure(
    minimumLevel: .info,
    enableConsole: true,
    enableFile: true,
    enableRemote: true,
    sentryDSN: "your_sentry_dsn_here"
)
```

## 📊 Log Levels

| Level | When to Use | Example |
|-------|-------------|---------|
| **Verbose** | Very detailed debugging | `logger.verbose("Received 1024 bytes from socket")` |
| **Debug** | Debugging info | `logger.debug("User tapped country cell")` |
| **Info** | General information | `logger.info("App started successfully")` |
| **Warning** | Unexpected but handled | `logger.warning("Cache miss, loading from network")` |
| **Error** | Errors that don't crash app | `logger.error("Failed to save to database")` |
| **Critical** | App-breaking errors | `logger.critical("Fatal error: nil database connection")` |

## 🎯 Best Practices

### 1. Use Appropriate Log Levels

```swift
// ✅ Good
logger.info("User logged in", category: "Auth")
logger.error("Failed to load countries", category: "Network")

// ❌ Bad
logger.debug("Database query executed")  // Too verbose
logger.error("User tapped button")      // Not an error
```

### 2. Add Context with Metadata

```swift
// ✅ Good
logger.error("API request failed", 
    category: "Network",
    metadata: ["url": url, "statusCode": statusCode])

// ❌ Bad
logger.error("API request failed")
```

### 3. Use Categories Wisely

```swift
// Good categories
"App"          // General app events
"Network"      // Network requests
"Database"     // Database operations
"UI"           // UI events
"Auth"         // Authentication
"Security"     // Security events
```

### 4. Don't Log Sensitive Information

```swift
// ❌ Bad
logger.info("User logged in", metadata: ["password": userPassword])

// ✅ Good
logger.info("User logged in", metadata: ["userId": user.id])
```

## 🔍 Debugging

### View Logs in Xcode Console

When running in debug mode, logs appear in Xcode console with colors.

### Export Logs from Device

```swift
// Get log file path
let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
let logsPath = documentsPath.appendingPathComponent("Logs")
print("Logs directory: \(logsPath.path)")

// Export via share sheet
let activityVC = UIActivityViewController(activityItems: [logsPath], applicationActivities: nil)
```

## 📱 Integration

Logger is automatically initialized in `AppEnvironment.bootstrap()`:

```swift
// AppDelegate.swift
let environment = AppEnvironment.bootstrap()
// Logger is now configured based on environment!
```

## 🚀 Advanced Usage

### Custom Categories

```swift
let networkLogger = AppLogger.shared
networkLogger.info("Request sent", category: "HTTP")
```

### Structured Logging

```swift
logger.info("Event occurred", category: "Analytics",
    metadata: [
        "event": "purchase",
        "amount": 99.99,
        "currency": "USD",
        "itemId": "PRODUCT_123"
    ])
```

## 📚 See Also

- `EnvironmentConfig.swift` - Environment configuration
- `LogLevel.swift` - Log level definitions
- `LogDestination.swift` - Destination implementations
- `AppLogger.swift` - Main logger class

