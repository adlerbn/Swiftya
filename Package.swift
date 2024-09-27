// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Swiftya",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "Presentation",
      targets: ["Presentation"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Presentation",
      dependencies: []
    ),
    .testTarget(
      name: "PresentationTests",
      dependencies: ["Presentation"]
    ),
  ]
)
