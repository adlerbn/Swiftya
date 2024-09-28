// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "Swiftya",
  platforms: [
    .iOS(.v16)
  ],
  products: [
    .library(
      name: "Swiftya",
      targets: ["Swiftya"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Swiftya",
      dependencies: []
    ),
    .testTarget(
      name: "SwiftyaTests",
      dependencies: ["Swiftya"]
    ),
  ]
)
