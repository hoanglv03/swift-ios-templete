# SingerApp Configuration Guide

This directory contains environment-specific configuration files for SingerApp.

## 📁 File Structure

```
config/
├── README.md              # This file
├── env.example           # Template for environment files
├── env.development       # Development environment configuration
├── env.staging           # Staging environment configuration
└── env.production        # Production environment configuration
```

## 🔧 Setup Instructions

### 1. Development Setup (Local)

```bash
# Copy the example file
cp config/env.example config/env.development

# Edit with your local settings
nano config/env.development
```

### 2. Staging Setup

```bash
cp config/env.example config/env.staging
nano config/env.staging
```

### 3. Production Setup (GitLab CI/CD)

Production secrets are **NOT stored in files**. They are injected via GitLab CI/CD Variables.

## 🔐 GitLab CI/CD Variables

Add these variables in your GitLab project:
**Settings → CI/CD → Variables**

### Required Variables:

| Variable Name | Description | Protected | Masked |
|--------------|-------------|-----------|---------|
| `GITLAB_API_KEY` | Production API Key | ✅ | ✅ |
| `GITLAB_API_SECRET` | Production API Secret | ✅ | ✅ |
| `GITLAB_SENTRY_DSN` | Sentry DSN for error tracking | ✅ | ❌ |
| `PROD_API_URL` | Production API Base URL | ✅ | ❌ |
| `STAGING_API_KEY` | Staging API Key | ❌ | ✅ |
| `STAGING_API_URL` | Staging API Base URL | ❌ | ❌ |
| `APPLE_DEVELOPER` | Apple Developer Team ID | ✅ | ❌ |
| `PROD_PROFILE` | Production Provisioning Profile UUID | ✅ | ❌ |
| `STAGING_PROFILE` | Staging Provisioning Profile UUID | ❌ | ❌ |

## 🚀 How It Works

### Local Development
```swift
// In your Swift code
let config = EnvironmentConfig.shared
print(config.apiBaseURL)  // Uses env.development
```

### Staging/Production via GitLab
```yaml
# In .gitlab-ci.yml
before_script:
  - echo "API_KEY=${GITLAB_API_KEY}" >> config/env.production
```

## 📝 Adding New Configuration Keys

1. Add to `config/env.example`:
   ```bash
   MY_NEW_KEY=default_value
   ```

2. Add to `SingerApp/Core/Config/EnvironmentConfig.swift`:
   ```swift
   var myNewKey: String {
       value(for: "MY_NEW_KEY") ?? "default"
   }
   ```

3. Use in code:
   ```swift
   let value = EnvironmentConfig.shared.myNewKey
   ```

## ⚠️ Security Best Practices

### ✅ DO:
- Use GitLab CI/CD Variables for production secrets
- Keep `.env.*` files in `.gitignore`
- Rotate secrets regularly
- Use different keys for each environment

### ❌ DON'T:
- Commit secrets to Git
- Hard-code API keys in Swift files
- Share `.env.production` files
- Use production keys in development

## 🔄 Environment Detection

The app automatically detects the environment:

```swift
// In EnvironmentConfig.swift
enum AppEnvironment {
    case development  // Debug builds
    case staging     // STAGING build flag
    case production  // Release builds
}
```

## 🛠️ Build Commands

### Development
```bash
./scripts/build.sh development
# or
xcodebuild -scheme SingerApp -sdk iphonesimulator
```

### Staging
```bash
./scripts/build.sh staging
```

### Production (via GitLab)
```bash
git push origin staging  # Triggers staging pipeline
git push origin master   # Triggers production pipeline
```

## 📚 More Information

- See `SingerApp/Core/Config/EnvironmentConfig.swift` for implementation
- See `.gitlab-ci.yml` for CI/CD pipeline configuration
- See `scripts/build.sh` for build automation

