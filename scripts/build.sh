#!/bin/bash

# Build Script for SingerApp
# This script handles environment configuration and builds

set -e

ENVIRONMENT=${1:-development}
CONFIG_DIR="config"
BUILD_SCHEME="SingerApp"

echo "🔧 Building SingerApp for environment: $ENVIRONMENT"

# Load environment specific configuration
load_env() {
    local env_file="$CONFIG_DIR/env.$ENVIRONMENT"
    
    if [ ! -f "$env_file" ]; then
        echo "⚠️  Environment file not found: $env_file"
        echo "📝 Using default configuration..."
        return
    fi
    
    echo "📋 Loading configuration from: $env_file"
    export $(cat $env_file | grep -v '^#' | xargs)
}

# Get Xcode path
get_xcode_path() {
    local xcode_version=${XCODE_VERSION:-"15.0"}
    echo "/Applications/Xcode_${xcode_version}.app"
}

# Build for simulator
build_simulator() {
    local xcode_path=$(get_xcode_path)
    local simulator="iPhone 15"
    
    echo "🏗️  Building for Simulator: $simulator"
    xcodebuild \
        -project SingerApp.xcodeproj \
        -scheme "$BUILD_SCHEME" \
        -sdk iphonesimulator \
        -destination "platform=iOS Simulator,name=$simulator" \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        clean build
}

# Build for device
build_device() {
    local xcode_path=$(get_xcode_path)
    
    echo "🏗️  Building for Device"
    xcodebuild \
        -project SingerApp.xcodeproj \
        -scheme "$BUILD_SCHEME" \
        -configuration Release \
        -archivePath "build/SingerApp.xcarchive" \
        archive
}

# Main
case "$ENVIRONMENT" in
    development|dev)
        load_env
        build_simulator
        ;;
    staging|qa)
        load_env
        build_device
        ;;
    production|prod)
        load_env
        build_device
        ;;
    *)
        echo "❌ Unknown environment: $ENVIRONMENT"
        echo "Usage: ./scripts/build.sh [development|staging|production]"
        exit 1
        ;;
esac

echo "✅ Build completed for $ENVIRONMENT environment"

