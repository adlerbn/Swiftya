# Swiftya

Swiftya is a collection of reusable UI components designed for SwiftUI applications. These components are fully customizable, easy to integrate, and help developers quickly build beautiful UIs with SwiftUI.

## Features

- Custom layouts (Radical, Wrap)

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 16+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Swiftya as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/adlerbn/Swiftya.git", .upToNextMajor(from: "0.0.1"))
]
```

Normally you'll want to depend on the `Swiftya` target:

```swift
.product(name: "Swiftya", package: "Swiftya")
```
