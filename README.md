# SingerApp

A modern iOS app demonstrating **Clean Architecture** with **SwiftUI** and **SwiftData**. Built with best practices for maintainability, testability, and scalability.

## 📱 Overview

SingerApp is a SwiftUI application that displays information about countries using the [REST Countries API](https://restcountries.com/). This project serves as a comprehensive example of implementing Clean Architecture principles in a real-world iOS application.

### Key Features

- ✅ **Clean Architecture** - Clear separation of Presentation, Business Logic, and Data layers
- ✅ **SwiftUI** - Native UI with declarative syntax
- ✅ **SwiftData** - Modern persistence framework
- ✅ **Dependency Injection** - Native SwiftUI DI using `@Environment`
- ✅ **Programmatic Navigation** - Deep linking support with push notifications
- ✅ **Centralized State Management** - Redux-like `AppState` as single source of truth
- ✅ **Environment Configuration** - Three environments (Development, Staging, Production)
- ✅ **Comprehensive Logging** - Multi-destination logger with file and remote support
- ✅ **Full Test Coverage** - Including UI tests with ViewInspector
- ✅ **CI/CD Ready** - GitLab CI/CD pipeline configured
- ✅ **Modern Networking** - Built on async/await

## 🏗️ Architecture

The app follows Clean Architecture principles with three distinct layers:

```text
┌─────────────────────────────────────────────────┐
│           Presentation Layer (SwiftUI)           │
│  - Views (CountriesList, CountryDetails, etc.)  │
│  - No business logic, pure UI                    │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│         Business Logic Layer (Interactors)      │
│  - CountriesInteractor                          │
│  - ImagesInteractor                             │
│  - UserPermissionsInteractor                    │
│  - Communicate with Repositories                │
│  - Update AppState                              │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│        Data Access Layer (Repositories)         │
│  - WebAPI: CountriesWebRepository, etc.        │
│  - Database: SwiftData repositories             │
└─────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### Presentation Layer

- **SwiftUI Views** with no business logic
- State-driven UI using `@State`, `@Binding`, and `@Environment`
- Side effects triggered by user actions or view lifecycle

#### Business Logic Layer

- **Interactors** perform business operations
- Receive requests to perform work from Views
- Forward results to `AppState` or `Binding`
- Access Repositories for data operations
- Never return data directly to Views

#### Data Access Layer

- **Repositories** provide asynchronous API (`Publisher` from Combine)
- CRUD operations on backend or local database
- No business logic, just data access
- Used exclusively by Interactors

## 🛠️ Technologies

- **Swift 6.1** - Modern Swift with strict concurrency
- **SwiftUI** - Declarative UI framework
- **SwiftData** - Modern persistence framework
- **Combine** - Reactive programming
- **Async/Await** - Modern concurrency
- **Dependency Injection** - Native SwiftUI DI
- **ViewInspector** - UI testing framework

## 📁 Project Structure

```text
SingerApp/
├── Core/                          # Core application components
│   ├── App.swift                  # App entry point
│   ├── AppDelegate.swift          # App lifecycle management
│   ├── AppState.swift            # Centralized state management
│   ├── Config/
│   │   └── EnvironmentConfig.swift # Environment configuration
│   ├── Logger/                    # Logging system
│   └── DeepLinksHandler.swift    # Deep link handling
│
├── DependencyInjection/           # DI setup
│   ├── DIContainer.swift         # Dependency injection container
│   └── AppEnvironment.swift    # App environment management
│
├── Interactors/                   # Business logic layer
│   ├── CountriesInteractor.swift
│   ├── ImagesInteractor.swift
│   └── UserPermissionsInteractor.swift
│
├── Repositories/                  # Data access layer
│   ├── Models/                   # Data models
│   │   ├── Country.swift         # Country data model
│   │   ├── CountryCurrency.swift
│   │   ├── CountryDetails.swift
│   │   ├── AppSchema.swift       # SwiftData schema
│   │   └── MockedData.swift
│   ├── WebAPI/                   # Network repositories
│   │   ├── WebRepository.swift   # Base web repository
│   │   ├── CountriesWebRepository.swift
│   │   ├── ImagesWebRepository.swift
│   │   └── PushTokenWebRepository.swift
│   └── Database/                 # Database repositories
│       ├── CountriesDBRepository.swift
│       └── ModelContainer.swift
│
├── UI/                           # Presentation layer
│   ├── Common/                   # Shared UI components
│   │   ├── ErrorView.swift
│   │   ├── ImageView.swift
│   │   └── Query+Search.swift
│   ├── CountriesList/            # Countries list screen
│   │   ├── CountriesListView.swift
│   │   ├── CountryCell.swift
│   │   └── LocaleReader.swift
│   ├── CountryDetails/           # Country details screen
│   │   ├── CountryDetailsView.swift
│   │   ├── DetailRow.swift
│   │   └── ModalFlagView.swift
│   └── RootViewModifier.swift
│
├── Utilities/                     # Helper utilities
│   ├── CancelBag.swift           # Combine cancellables
│   ├── Helpers.swift             # General helpers
│   ├── Loadable.swift            # Loading state wrapper
│   └── Store.swift               # State store
│
├── Resources/                     # App resources
│   ├── Assets.xcassets           # Images and colors
│   └── Localizable.xcstrings    # Localization strings
│
├── config/                        # Environment configuration
│   ├── env.example               # Config template
│   └── README.md                 # Configuration guide
│
├── scripts/                       # Build scripts
│   └── build.sh                  # Build automation
│
├── docs/                          # Documentation
│   ├── ENVIRONMENT_SETUP.md      # Environment setup guide
│   ├── CONFIGURATION_SUMMARY.md  # Configuration architecture
│   └── LOGGER_SUMMARY.md         # Logging system guide
│
└── UnitTests/                     # Test suites
    ├── Mocks/                     # Mock implementations
    ├── Repositories/              # Repository tests
    ├── System/                    # System component tests
    └── UI/                        # UI tests
```

## 🚀 Getting Started

### Prerequisites

- **macOS 14.0+**
- **Xcode 15.0+**
- **iOS 18.0+ SDK**
- **Swift 6.1**

### Installation

1. **Clone the repository**

   ```bash
   git clone https://gitlab.com/your-team/singerapp.git
   cd singerapp
   ```

2. **Setup environment configuration**

   ```bash
   # Copy the example config
   cp config/env.example config/env.development
   
   # Edit with your local settings (optional)
   nano config/env.development
   ```

3. **Open in Xcode**

   ```bash
   open SingerApp.xcodeproj
   ```

4. **Build and Run**
   - Select a simulator (iPhone 15 Pro recommended)
   - Press `Cmd + R` to build and run

### Quick Build Script

Alternatively, use the build script:

```bash
# For development
./scripts/build.sh development

# For staging
./scripts/build.sh staging

# For production (requires GitLab CI/CD setup)
./scripts/build.sh production
```

## ⚙️ Configuration

### Environment Setup

The project supports three environments:

1. **Development** - Local development with debug logging
2. **Staging** - Testing environment with signed builds
3. **Production** - Production environment with secrets from GitLab

### Configuration Files

Environment files are located in `config/` directory:

```bash
config/
├── env.example          # Template for all environments
├── env.development      # Development config (committed)
├── env.staging          # Staging config (committed)
└── env.production       # Production template (secrets from GitLab)
```

### Using Environment Config

```swift
import Foundation

// Get shared config instance
let config = EnvironmentConfig.shared

// API configuration
let apiURL = config.apiBaseURL
// Development: "https://restcountries.com/v2"
// Staging: "https://api.staging.countries.com"
// Production: "https://restcountries.com/v2"

// Feature flags
if config.enableAnalytics {
    // Track user events
}

// Logging
let logLevel = config.logLevel
// Development: "debug"
// Staging: "info"  
// Production: "error"

// Secrets (from .env files or GitLab CI/CD)
let apiKey = config.apiKey
```

### Adding New Configuration

1. **Add to env files**

   ```bash
   # config/env.development
   NEW_FEATURE_ENABLED=true
   MY_API_ENDPOINT=https://api.dev.com
   ```

2. **Add to EnvironmentConfig.swift**

   ```swift
   extension EnvironmentConfig {
       var newFeatureEnabled: Bool {
           boolValue(for: "NEW_FEATURE_ENABLED")
       }
       
       var myApiEndpoint: String {
           value(for: "MY_API_ENDPOINT") ?? "https://default.com"
       }
   }
   ```

3. **Use in your code**

   ```swift
   if EnvironmentConfig.shared.newFeatureEnabled {
       // Enable feature
   }
   ```

For detailed configuration guide, see [`config/README.md`](config/README.md) and [`docs/ENVIRONMENT_SETUP.md`](docs/ENVIRONMENT_SETUP.md).

## 🧪 Testing

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme SingerApp -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Run specific test suite
xcodebuild test -scheme SingerApp -destination 'platform=iOS Simulator,name=iPhone 15 Pro' -only-testing:UnitTests/CountriesListTests
```

### Test Structure

```text
UnitTests/
├── Mocks/               # Mock implementations for testing
├── Repositories/        # Repository tests
├── System/              # System component tests  
├── UI/                  # UI tests with ViewInspector
└── Utilities/           # Utility tests
```

### Writing Tests

```swift
import XCTest
@testable import SingerApp

class CountriesInteractorTests: XCTestCase {
    
    func testLoadCountries() {
        let container = DIContainer()
        let interactor = CountriesInteractor(container: container)
        
        // Test implementation
    }
}
```

## 📝 Key Concepts for New Developers

### 1. AppState - Centralized State

`AppState` is the single source of truth for application-wide state:

```swift
final class AppState: ObservableObject {
    @Published var routing = ViewRouting()  // Navigation state
    @Published var userData = UserData()    // User data
}
```

### 2. Interactors - Business Logic

Interactors contain all business logic and coordinate between repositories:

```swift
struct CountriesInteractor: CountriesInteracting {
    let container: DIContainer
    
    func loadCountries() {
        // Load from database or API
        // Update AppState
    }
}
```

### 3. Repositories - Data Access

Repositories provide async APIs for data operations:

```swift
protocol CountriesWebRepository {
    func loadCountries() -> AnyPublisher<[ApiModel.Country], Error>
}
```

### 4. Dependency Injection

Native SwiftUI dependency injection using `@Environment`:

```swift
struct MyView: View {
    @Environment(\.countriesInteractor) var interactor
    
    var body: some View {
        // Use interactor here
    }
}
```

### 5. Logger - Logging System

Use the global logger for all logging:

```swift
import Foundation

let logger = AppLogger.shared

logger.info("User logged in", category: "Auth")
logger.debug("Loading countries", category: "Network")
logger.error("Failed to save", category: "Database")
```

See [`docs/LOGGER_SUMMARY.md`](docs/LOGGER_SUMMARY.md) for detailed logging guide.

### 6. View Lifecycle

Side effects are triggered in view lifecycle:

```swift
struct MyView: View {
    var body: some View {
        List(items) { item in
            // View content
        }
        .onAppear {
            interactor.loadData()  // Trigger side effect
        }
    }
}
```

## 🚢 Deployment

### CI/CD Setup

The project includes GitLab CI/CD configuration for automated deployment:

1. **Add GitLab Variables** (Settings → CI/CD → Variables)

   ```bash
   # Production secrets (MUST be Protected and Masked)
   GITLAB_API_KEY=your_production_api_key
   GITLAB_API_SECRET=your_production_secret  
   GITLAB_SENTRY_DSN=https://xxx@sentry.io/xxx
   
   # Configuration
   PROD_API_URL=https://restcountries.com/v2
   STAGING_API_URL=https://api.staging.countries.com
   
   # Apple Developer
   APPLE_DEVELOPER=YourTeamName
   PROD_PROFILE=your_provisioning_profile_uuid
   STAGING_PROFILE=your_staging_profile_uuid
   ```

2. **Push to trigger pipeline**

   ```bash
   git push origin staging   # Deploy to staging
   git push origin master    # Deploy to production
   ```

See `.gitlab-ci.yml` for detailed CI/CD configuration.

## 📚 Documentation

- [`docs/ENVIRONMENT_SETUP.md`](docs/ENVIRONMENT_SETUP.md) - Environment setup guide
- [`docs/CONFIGURATION_SUMMARY.md`](docs/CONFIGURATION_SUMMARY.md) - Configuration architecture
- [`docs/LOGGER_SUMMARY.md`](docs/LOGGER_SUMMARY.md) - Logging system guide
- [`config/README.md`](config/README.md) - Configuration guide
- [`CONFIGURATION_README.md`](CONFIGURATION_README.md) - Configuration overview

## 🌟 Best Practices

### Code Organization

- **Views** contain no business logic
- **Interactors** coordinate data flow
- **Repositories** only handle data access
- **Models** separate for API and Database layers

### State Management

- Use `AppState` for app-wide state
- Use `@State` for local view state
- Use `@Binding` for parent-child communication

### Testing

- Mock repositories in tests
- Test interactors with mock repositories
- Test views with ViewInspector
- Aim for >80% code coverage

### Performance

- Lazy load data when needed
- Cache frequently used data
- Use Combine for reactive updates
- Profile with Instruments

## 🔀 Git Workflow

This project follows a structured Git workflow to ensure code quality and team collaboration.

### Branch Naming Conventions

All branches should follow these naming patterns:

| Branch Type | Prefix | Example | Description |
|-------------|--------|---------|-------------|
| Feature | `feature/` | `feature/add-user-profile` | New features or enhancements |
| Bug Fix | `bugfix/` | `bugfix/fix-crash-on-login` | Bug fixes |
| Hotfix | `hotfix/` | `hotfix/critical-security-patch` | Critical production fixes |
| Refactor | `refactor/` | `refactor/improve-networking-layer` | Code refactoring |
| Documentation | `docs/` | `docs/update-readme` | Documentation updates |

**Branch Name Rules:**

- ✅ Use lowercase letters
- ✅ Separate words with hyphens (`-`)
- ✅ Use descriptive names (what and why)
- ✅ Keep names concise but clear
- ❌ No spaces or special characters except hyphens

**Examples:**

```bash
# ✅ Good branch names
feature/add-dark-mode-support
bugfix/fix-memory-leak-in-image-loader
refactor/simplify-state-management
hotfix/critical-api-timeout-issue

# ❌ Bad branch names
feature/userAuthentication  # Wrong: camelCase
bugfix/fix bug             # Wrong: contains space
feature/123-update          # Wrong: unclear purpose
hotfix/patch1               # Wrong: generic name
```

### Commit Message Conventions

We follow the **Conventional Commits** specification for commit messages:

```text
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

#### Commit Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(ui): add dark mode toggle` |
| `fix` | Bug fix | `fix(api): resolve timeout on slow network` |
| `docs` | Documentation | `docs(readme): update installation steps` |
| `style` | Code style changes | `style(ui): format country cell` |
| `refactor` | Code refactoring | `refactor(logger): simplify log levels` |
| `perf` | Performance improvement | `perf(db): optimize queries` |
| `test` | Test additions/changes | `test(interactor): add countries tests` |
| `chore` | Build tasks, dependencies | `chore(deps): update swift version` |
| `ci` | CI/CD changes | `ci(gitlab): add staging pipeline` |

#### Commit Message Format

```text
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

**Rules:**

- ✅ Subject line: max 50 characters
- ✅ Use imperative mood ("add" not "adds" or "added")
- ✅ Start with lowercase
- ✅ No period at the end
- ✅ Body explains what and why
- ✅ Footer for breaking changes or issue references

**Examples:**

```bash
# ✅ Good commit messages
feat(ui): add country search functionality
fix(api): resolve authentication timeout issue
docs(readme): add git workflow guidelines
refactor(logger): simplify log level configuration

# ✅ With body
feat(network): implement retry mechanism

Implement exponential backoff retry for failed API calls.
Adds configurable max retry attempts and timeout settings.

Closes #123

# ❌ Bad commit messages
Updated README                    # Missing type and scope
FEAT: Added new feature           # Wrong: all caps
fix bug                           # Too vague
feat(auth) Implement login        # Wrong: use imperative mood
```
