#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$PROJECT_DIR/FourteenZoneTask.xcodeproj"
SCHEME="FourteenZoneTask"
ARCHIVE_PATH="$PROJECT_DIR/build/FourteenZoneTask.xcarchive"
EXPORT_PATH="$PROJECT_DIR/build/ipa"
EXPORT_OPTIONS="$PROJECT_DIR/Scripts/ExportOptions.plist"

echo "==> Cleaning previous build artifacts..."
rm -rf "$PROJECT_DIR/build"

echo "==> Archiving app..."
xcodebuild archive \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO

echo "==> Exporting IPA..."
mkdir -p "$EXPORT_PATH"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  CODE_SIGNING_ALLOWED=NO

echo "==> IPA exported to: $EXPORT_PATH/FourteenZoneTask.ipa"
