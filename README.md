# Uplift iOS Client 
[![GitHub release](https://img.shields.io/github/release/cuappdev/fitness-ios.svg)]()
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)]()
[![GitHub contributors](https://img.shields.io/github/contributors/cuappdev/fitness-ios.svg)]()
[![Build Status](https://travis-ci.org/cuappdev/clicker-ios.svg?branch=master)](https://travis-ci.org/cuappdev/fitness-ios)

Fitness is one of the latest apps by [Cornell AppDev](http://cornellappdev.com), a project team at Cornell University.

## Installation
We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

Clone the project with
```
git clone https://github.com/cuappdev/uplift-ios.git
```

After cloning the project, `cd` into the new directory and install dependencies with
```
pod install
```
Open the Clicker Xcode workspace, `Uplift.xcworkspace`.

## Configuration (optional)
We store secret keys for Fabric. To use Fabric, include a `Keys.plist` file under a `Secrets/` directory with your `fabric-api-key` string value and `fabric-build-secret` string value.
