// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BigCombinatorics",
    dependencies: [
      .package(url:"https://github.com/dankogai/swift-bignum.git", from:"6.3.1"),
      .package(url:"..", branch:"main"),
    ],
    targets: [
        .executableTarget(
            name: "BigCombinatorics",
            dependencies: [
                .product(name:"BigNum", package:"swift-bignum"),
                .product(name:"Combinatorics", package:"swift-combinatorics"),
            ]),
    ]
)
