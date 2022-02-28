// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "BIP32",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BIP32",
            targets: ["BIP32"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/attaswift/BigInt.git",
            .upToNextMajor(from: "5.3.0")
        ),
        .package(
            name: "secp256k1",
            url: "https://github.com/GigaBitcoin/secp256k1.swift.git",
            .upToNextMajor(from: "0.4.0")
        ),
        .package(
            name: "RIPEMD160",
            url: "https://github.com/anquii/RIPEMD160.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            name: "Base58Check",
            url: "https://github.com/anquii/Base58Check.git",
            .upToNextMajor(from: "1.0.0")
        ),
    ],
    targets: [
        .binaryTarget(
            name: "CryptoSwift",
            url: "https://github.com/krzyzanowskim/CryptoSwift/releases/download/1.4.3/CryptoSwift.xcframework.zip",
            checksum: "5eaa8fe30805789ad5472edb27182d41afecf1283f0c6efb0afc9261b28f5cf6"
        ),
        .target(
            name: "BIP32",
            dependencies: [
                "CryptoSwift",
                "BigInt",
                "secp256k1",
                "RIPEMD160",
                "Base58Check"
            ]
        ),
        .testTarget(
            name: "BIP32Tests",
            dependencies: ["BIP32"]
        )
    ]
)
