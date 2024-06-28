#!/bin/bash

# This is a script that clones the swift-collection repository and prebuilds it
# into an XCFramework. The framework is then zipped and exposed through a Swift package 
# that can be included in the app

set -eo pipefail

# Utils

printTitle() {
  # blue text
  echo -e "\033[34m• $1\033[0m"
}

printConfirmation() {
  # green text
  echo -e "\033[32m↪ $1\033[0m"
}

# Start of the script

TARGET_FOLDER="swift-collections"
REPO="https://github.com/apple/swift-collections.git"
TAG="1.1.1"

if [ ! -d "$TARGET_FOLDER" ]; then
  echo "> Cloning $REPO"
  git clone --depth 1 --branch "$TAG" -c advice.detachedHead=false "$REPO" "$TARGET_FOLDER"
else
  echo "> $TARGET_FOLDER already exists, no need to clone."
fi

cd "$TARGET_FOLDER"

swift package update

BUILD_FOLDER="../build"
MAC_BUILD_FOLDER="$BUILD_FOLDER/macos"
IOS_BUILD_FOLDER="$BUILD_FOLDER/ios"
IOS_SIM_BUILD_FOLDER="$BUILD_FOLDER/ios-simulator"
XCF_BUILD_FOLDER="../xcframework"
XCODE_PROJS_DIR="./Xcode"

rm -rf "$BUILD_FOLDER"
rm -rf "$XCF_BUILD_FOLDER"

mkdir -p "$MAC_BUILD_FOLDER"
mkdir -p "$IOS_BUILD_FOLDER"
mkdir -p "$IOS_SIM_BUILD_FOLDER"
mkdir -p "$XCF_BUILD_FOLDER"


# To list all schemes into the xcproject
# xcodebuild -list -project "$XCODE_PROJS_DIR/Collections.xcodeproj"

printTitle "Building Collections for iOS"

xcodebuild archive \
  -project "$XCODE_PROJS_DIR/Collections.xcodeproj" \
  -scheme "Collections" \
  -destination "generic/platform=iOS" \
  -archivePath "$IOS_BUILD_FOLDER/Collections.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO

printTitle "Building Collections for iOS Simulator"

xcodebuild archive \
  -project "$XCODE_PROJS_DIR/Collections.xcodeproj" \
  -scheme "Collections" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$IOS_SIM_BUILD_FOLDER/Collections.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO

printTitle "Building Collections for macOS"

xcodebuild archive \
  -project "$XCODE_PROJS_DIR/Collections.xcodeproj" \
  -scheme Collections \
  -destination "generic/platform=macOS" \
  -archivePath "$MAC_BUILD_FOLDER/Collections.xcarchive" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  CODE_SIGNING_ALLOWED=NO

printTitle "Creating XCFramework"

xcodebuild -create-xcframework \
  -archive "$IOS_BUILD_FOLDER/Collections.xcarchive" -framework "Collections.framework" \
  -archive "$IOS_SIM_BUILD_FOLDER/Collections.xcarchive" -framework "Collections.framework" \
  -archive "$MAC_BUILD_FOLDER/Collections.xcarchive" -framework "Collections.framework" \
  -output "$XCF_BUILD_FOLDER/swift-collections.xcframework"

printTitle "Zipping XCFramework"

cd "$XCF_BUILD_FOLDER"

zip -r \
  "swift-collections.xcframework.zip" \
  "swift-collections.xcframework"

rm -rf "swift-collections.xcframework"

printConfirmation "Done"