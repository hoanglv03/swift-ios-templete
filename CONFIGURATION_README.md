# 🎯 SingerApp - Configuration System

## 📋 Tổng Quan

Dự án SingerApp hiện đã được setup hệ thống configuration giống như file `.env` trong Node.js với **3 environments**:
- 🔵 **Development** - Local development
- 🟡 **Staging** - Testing với signed builds
- 🟢 **Production** - Production với secrets từ GitLab

## 🚀 Quick Start

### 1. Setup Local Development

```bash
# Copy environment file
cp config/env.example config/env.development

# Edit với settings của bạn
nano config/env.development

# Build cho development
./scripts/build.sh development
```

### 2. GitLab CI/CD Setup (Production)

Go to your GitLab project: **Settings → CI/CD → Variables**

#### Add these Variables:

```bash
# Production Secrets (BẮT BUỘC phải ✅ Protected và ✅ Masked)
GITLAB_API_KEY=your_production_api_key
GITLAB_API_SECRET=your_production_secret  
GITLAB_SENTRY_DSN=https://xxx@sentry.io/xxx

# Configuration
PROD_API_URL=https://restcountries.com/v2
STAGING_API_URL=https://api.staging.com

# Apple Developer
APPLE_DEVELOPER=YourTeamName
PROD_PROFILE=your_provisioning_profile_uuid
STAGING_PROFILE=your_staging_profile_uuid
```

Sau đó push code:
```bash
git push origin staging   # Deploy to staging
git push origin master    # Deploy to production
```

## 📁 Cấu Trúc Files

```
SingerApp/
├── Core/
│   └── Config/
│       └── EnvironmentConfig.swift    ← Main config manager
│
├── config/
│   ├── env.example                    ← Template
│   ├── env.development                ← Development config
│   ├── env.staging                    ← Staging config
│   └── env.production                 ← Production template
│
├── scripts/
│   └── build.sh                       ← Build automation
│
├── docs/
│   ├── ENVIRONMENT_SETUP.md          ← Setup guide
│   └── CONFIGURATION_SUMMARY.md      ← Architecture details
│
├── .gitlab-ci.yml                     ← CI/CD pipeline
└── .gitignore                         ← Security rules
```

## 💻 Sử Dụng Trong Code

```swift
import Foundation

// Lấy config
let config = EnvironmentConfig.shared

// API Base URL (tự động theo environment)
let apiURL = config.apiBaseURL
// Development: "https://restcountries.com/v2"
// Staging: "https://api.staging.countries.com"  
// Production: "https://restcountries.com/v2"

// Feature flags
if config.enableAnalytics {
    // Track events
}

// Logging
print("Log level: \(config.logLevel)")

// Secrets (từ GitLab CI/CD hoặc env files)
let apiKey = config.apiKey
let apiSecret = config.apiSecret
```

## 🔐 Security

### ✅ ĐÚNG

```swift
// Lấy từ EnvironmentConfig
let key = EnvironmentConfig.shared.apiKey

// GitLab CI/CD injects vào environment
// Development: từ env.development
// Production: từ GITLAB_API_KEY variable
```

### ❌ SAI

```swift
// KHÔNG BAO GIỜ làm thế này!
let apiKey = "sk_live_1234567890"  // ❌ Secret bị expose
```

## 🔄 Environment Flow

### Development
```
Local Machine
    ↓
Load: config/env.development
    ↓
EnvironmentConfig.swift
    ↓
API calls với dev settings
```

### Staging  
```
GitLab CI/CD
    ↓  
Load: env.staging + STAGING_API_KEY
    ↓
Build signed artifacts
    ↓
Deploy to TestFlight
```

### Production
```
GitLab CI/CD (master branch)
    ↓
Load GitLab Variables:
  - GITLAB_API_KEY
  - GITLAB_API_SECRET  
  - GITLAB_SENTRY_DSN
    ↓
Build signed production artifacts
    ↓
Upload to App Store
```

## 📝 Thêm Config Mới

### 1. Add vào env files
```bash
# config/env.development
NEW_FEATURE=my_new_value
```

### 2. Add vào EnvironmentConfig.swift  
```swift
extension EnvironmentConfig {
    var newFeatureValue: String {
        value(for: "NEW_FEATURE") ?? "default"
    }
}
```

### 3. Sử dụng
```swift
let value = EnvironmentConfig.shared.newFeatureValue
```

## 🎯 Environment Matrix

| Setting | Development | Staging | Production |
|---------|------------|---------|------------|
| API URL | restcountries.com/v2 | staging.com | restcountries.com/v2 |
| Analytics | ❌ | ✅ | ✅ |
| Crash Reporting | ❌ | ✅ | ✅ |
| Log Level | debug | info | error |
| API Keys | Dev keys | Staging keys | **GitLab** |
| Source | env.development | env.staging | **CI/CD vars** |

## 📚 Documentation

- [`config/README.md`](config/README.md) - Configuration guide
- [`docs/ENVIRONMENT_SETUP.md`](docs/ENVIRONMENT_SETUP.md) - Detailed setup
- [`docs/CONFIGURATION_SUMMARY.md`](docs/CONFIGURATION_SUMMARY.md) - Architecture

## ✅ Checklist

- [x] Environment files created
- [x] EnvironmentConfig.swift implemented
- [x] Repositories updated to use config
- [x] GitLab CI/CD configured
- [x] Build scripts created
- [x] .gitignore updated (security)
- [x] Documentation written
- [ ] **Your turn**: Add GitLab CI/CD Variables
- [ ] **Your turn**: Test staging build
- [ ] **Your turn**: Deploy to production

## 🎉 Hoàn Thành!

Hệ thống configuration đã sẵn sàng. Bây giờ bạn có:
- ✅ Configuration như `.env` trong Node.js
- ✅ 3 environments hoàn chỉnh  
- ✅ GitLab CI/CD integration
- ✅ Secure secret management
- ✅ Build automation
- ✅ Complete documentation

**Next**: Thêm GitLab CI/CD Variables và test build!

