
# SkipTools-Legacy
Skip's Tools SDK (Legacy)

![Version](https://img.shields.io/github/v/release/goSkip/SkipTools-Legacy)

### Table of Contents

* [SDK Installation](#installation)
  * [Swift Package Manager](#swift-package-manager)
  * [Manual installation](#manual-installation)
* [Configuration](#configuration)
* [Launching Skip](#launching-skip)

# Installation 

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding ShopperLegacy-SDK as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/GoSkip/SkipTools-Legacy/", .upToNextMajor(from: "4.0.0"))
]
```

## Manual Installation
[View full install guide](https://goskip.github.io/mco/wiki/ios/installation/)

### Step 1: Download the the latest release of `SkipTools.xcframework.zip`
- [Releases](https://github.com/GoSkip/SkipTools-Legacy-Source/releases)

### Step 2: Unzip the `SkipTools.xcframework.zip` file you just downloaded

### Step 3: Add the Skip SDK to your Xcode project

- Drag and drop the SkipTools.xcframework into your project

- Check 'Copy items if needed' and 'Create groups' 

- Click Finish.

### Step 4: Set the Deployment Target

You’ll next need to ensure that your Deployment Target is set to at least 10.0, which is the minimum iOS version the Skip SDK is compatible with.

This can be set by editing your project build settings by double clicking on your project’s root entry, selecting the General tab, and editing the Deployment Target.

Set deployment target to iOS 10.0

### Step 5: Set the library to Embed and Sign

This new framework will need to be embedded in your app and signed. This setting can be found under the General settings page of your app target.

Be sure that Embedded and Signed is set

### Step 6: Update App Info.plist

The Skip SDK requires Location and Camera access. In order for the framework to request these permissions, the following lines need to be added into the App’s Info.plist.

- NSCameraUsageDescription
- NSLocationWhenInUseUsageDescription
- NSPhotoLibraryUsageDescription
- Required info.plist Setting
- Full info.plist Setting

### Step 7: Import SkipTools

Within the file where you want to launch the Skip SDK from, import SkipTools at the top of the file.

### Step 8: Launch the Skip Experience

In order to launch the Skip experience, you will need to call the SkipSDK.launchSkip function.

---
# Configuration

The SkipSDK.launchSkip function takes in a SkipSDK.Config parameter. This Config parameter sets up how the SDK will behave and has several parameters that must be set. In the following section we will cover each of those parameters and how they affect the functionality of the Skip SDK.

[View Configuration Guide](https://goskip.github.io/mco/wiki/ios/configuration/)

# Launching Skip
Now that you've got the configuration nailed down, it's time to launch the Skip experience. Below you will find examples of a few common scenarios and how to launch those scenarios.

- [Launch Scan & Go](https://goskip.github.io/mco/wiki/ios/launch/scanandgo/)
- [Launch Order Ahead](https://goskip.github.io/mco/wiki/ios/launch/orderahead/)
