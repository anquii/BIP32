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
            url: "https://github.com/anquii/CryptoSwiftWrapper.git",
            from: "1.4.3"
        ),
        .package(
            url: "https://github.com/attaswift/BigInt.git",
            .upToNextMajor(from: "5.3.0")
        ),
        .package(
            name: "secp256k1",
            url: "https://github.com/GigaBitcoin/secp256k1.swift.git",
            .exact("0.5.0")
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
        )
    ],
    targets: [
        .target(
            name: "BIP32",
            dependencies: [
                "CryptoSwiftWrapper",
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
