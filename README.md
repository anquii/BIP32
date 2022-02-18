# BIP32

[![Platform](https://img.shields.io/badge/Platforms-macOS%20%7C%20iOS-blue)](#platforms)
[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-orange)](#swift-package-manager)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/anquii/BIP32/blob/main/LICENSE)

An implementation of [BIP-0032](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) in Swift.

## Platforms
- macOS 10.15+
- iOS 13+

## Installation

### Swift Package Manager

Add the following line to your `Package.swift` file:
```swift
.package(url: "https://github.com/anquii/BIP32.git", from: "0.1.0")
```
...or integrate with Xcode via `File -> Swift Packages -> Add Package Dependency...` using the URL of the repository.

## License

BIP32 is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more information.

## Acknowledgments

In developing BIP32, [KevinVitale](https://github.com/KevinVitale)'s [WalletKit](https://github.com/KevinVitale/WalletKit) has been used as a reference implementation. In addition, BIP32 depends on [krzyzanowskim](https://github.com/krzyzanowskim)'s [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) and [GigaBitcoin](https://github.com/GigaBitcoin)'s [secp256k1.swift](https://github.com/GigaBitcoin/secp256k1.swift) for crypto operations.
