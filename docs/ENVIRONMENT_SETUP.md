# Environment Setup Guide

## Quick Start

### 1. Clone Repository
```bash
git clone https://gitlab.com/your-team/singerapp.git
cd singerapp
```

### 2. Setup Local Environment
```bash
# Copy example configuration
cp config/env.example config/env.development

# Edit with your local settings
nano config/env.development
```

### 3. Build and Run
```bash
# For development
./scripts/build.sh development

# Or open in Xcode
open SingerApp.xcodeproj
```

## Environment Configuration

### Development (`env.development`)
```bash
ENVIRONMENT=development
API_BASE_URL=https://restcountries.com/v2
LOG_LEVEL=debug
ENABLE_ANALYTICS=false
```

### Staging (`env.staging`)
```bash
ENVIRONMENT=staging
API_BASE_URL=https://api.staging.countries.com
LOG_LEVEL=info
ENABLE_ANALYTICS=true
```

### Production (`env.production`)
Production config is managed via GitLab CI/CD Variables.

## GitLab CI/CD Setup

### Step 1: Add Variables in GitLab

Go to your GitLab project:
**Settings → CI/CD → Variables → Expand**

#### Add Required Variables:

```bash
# Production Secrets (Protected + Masked)
GITLAB_API_KEY=prod_api_key_here
GITLAB_API_SECRET=prod_secret_here
GITLAB_SENTRY_DSN=https://xxx@sentry.io/project

# Configuration
PROD_API_URL=https://restcountries.com/v2
STAGING_API_URL=https://api.staging.countries.com

# Apple Developer
APPLE_DEVELOPER=TeamName
PROD_PROFILE=xxxxx-xxxxx-xxxxx
STAGING_PROFILE=xxxxx-xxxxx-xxxxx
```

### Step 2: Configure Build Variants

In Xcode, add Build Configurations:

1. Open `SingerApp.xcodeproj`
2. Select the project
3. Go to **Info** tab
4. Under **Configurations**, add:
   - **Debug** (Development)
   - **Staging** (Staging)
   - **Release** (Production)

### Step 3: Add Build Script

Add a **Run Script** phase in Xcode:

```bash
# Path: SingerApp Target → Build Phases → + Run Script
#!/bin/bash

# Copy environment file to bundle
ENV_FILE="config/env.${CONFIGURATION}"
if [ -f "$ENV_FILE" ]; then
    cp "$ENV_FILE" "${BUILT_PRODUCTS_DIR}/env.${CONFIGURATION}"
fi
```

## Testing Configuration

### Check Current Environment
```swift
// In your Swift code
let config = EnvironmentConfig.shared
print("Environment: \(config.env.rawValue)")
print("API URL: \(config.apiBaseURL)")
```

### Verify Secrets
```swift
// Check if API key is loaded (never print in production!)
#if DEBUG
print("API Key loaded: \(!config.apiKey.isEmpty)")
#endif
```

## Troubleshooting

### Problem: Config not loading

**Solution:**
1. Check if `.env` file exists in `config/` directory
2. Verify file is included in Xcode build phase
3. Check file format (no spaces around `=`)

### Problem: GitLab secrets not working

**Solution:**
1. Verify variables are marked as **Protected** for production
2. Check variable names match exactly (case-sensitive)
3. Ensure branch is protected

### Problem: Build fails with missing config

**Solution:**
1. Add fallback in `EnvironmentConfig.swift`
2. Check `.gitignore` isn't excluding config files
3. Verify build script permissions: `chmod +x scripts/build.sh`

## Security Checklist

- [ ] `.env.*` files in `.gitignore`
- [ ] Production secrets in GitLab Variables only
- [ ] All secrets marked as **Protected** and **Masked**
- [ ] Different keys for each environment
- [ ] No hard-coded secrets in Swift files
- [ ] Secrets rotated quarterly
- [ ] Use App Sandbox for file access

