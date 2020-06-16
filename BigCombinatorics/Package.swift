// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BigCombinatorics",
    dependencies: [
      .package(url:"https://github.com/attaswift/BigInt.git", from:"5.0.0"),
      .package(url:"..", .branch("master")),
    ],
    targets: [
        .target(
            name: "BigCombinatorics",
            dependencies: ["BigInt", "Combinatorics"]),
    ]
)
