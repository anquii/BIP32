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
.package(url: "https://github.com/anquii/BIP32.git", from: "1.0.0")
```
...or integrate with Xcode via `File -> Swift Packages -> Add Package Dependency...` using the URL of the repository.

## License

`BIP32` is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more information.

## Usage

```swift
import BIP32

let privateMasterKeyDerivator: PrivateMasterKeyDerivating = PrivateMasterKeyDerivator()
let publicMasterKeyDerivator: PublicMasterKeyDerivating = PublicMasterKeyDerivator()
let privateChildKeyDerivator: PrivateChildKeyDerivating = PrivateChildKeyDerivator()
let keyFingerprintDerivator: KeyFingerprintDerivating = KeyFingerprintDerivator()
let keyIndexHardener: KeyIndexHardening = KeyIndexHardener()
let keySerializer: KeySerializing = KeySerializer()
let serializedKeyCoder: SerializedKeyCoding = SerializedKeyCoder()

let privateMasterKey = try privateMasterKeyDerivator.privateMasterKey(seed: seed)
let privateMasterKeyAttributes = MasterKeyAttributes(accessControl: .`private`, version: version)
let serializedPrivateMasterKey = try keySerializer.serializedKey(extendedKey: privateMasterKey, attributes: privateMasterKeyAttributes)
let encodedPrivateMasterKey = serializedKeyCoder.encode(serializedKey: serializedPrivateMasterKey)
// e.g. xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi

let publicMasterKey = try publicMasterKeyDerivator.publicKey(privateKey: privateMasterKey)
let publicMasterKeyAttributes = MasterKeyAttributes(accessControl: .`public`, version: version)
let serializedPublicMasterKey = try keySerializer.serializedKey(extendedKey: publicMasterKey, attributes: publicMasterKeyAttributes)
let encodedPublicMasterKey = serializedKeyCoder.encode(serializedKey: serializedPublicMasterKey)
// e.g. xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8

let hardenedIndex = try keyIndexHardener.hardenedIndex(normalIndex: index)
let parentKeyFingerprint = keyFingerprintDerivator.fingerprint(publicKey: publicMasterKey.key)
let privateChildKey = try privateChildKeyDerivator.privateChildKey(privateParentKey: privateMasterKey, index: hardenedIndex)
let privateChildKeyAttributes = ChildKeyAttributes(accessControl: .`private`, version: version, depth: depth, parentKeyFingerprint: parentKeyFingerprint, index: hardenedIndex)
let serializedPrivateChildKey = try keySerializer.serializedKey(extendedKey: privateChildKey, attributes: privateChildKeyAttributes)
let encodedPrivateChildKey = serializedKeyCoder.encode(serializedKey: serializedPrivateChildKey)
// e.g. xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7

...for more examples, please have a look at the tests
```

## Acknowledgments

In developing `BIP32`, [KevinVitale](https://github.com/KevinVitale)'s [WalletKit](https://github.com/KevinVitale/WalletKit) has been used as a reference implementation. In addition, `BIP32` depends on [krzyzanowskim](https://github.com/krzyzanowskim)'s [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift), [GigaBitcoin](https://github.com/GigaBitcoin)'s [secp256k1.swift](https://github.com/GigaBitcoin/secp256k1.swift) and [attaswift](https://github.com/attaswift)'s [BigInt](https://github.com/attaswift/BigInt).
