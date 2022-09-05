// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "Swiftya",
  products: [
    .library(
      name: "Swiftya",
      targets: ["Swiftya"]
    ),
  ],
  dependencies: [
  ],
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
