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

## Usage

```swift
import BIP32

let keySerializer: KeySerializing = KeySerializer()
let serializedKeyCoder: SerializedKeyCoding = SerializedKeyCoder()

let privateMasterKeyDerivator: PrivateMasterKeyDerivating = PrivateMasterKeyDerivator()
let privateMasterKey = try privateMasterKeyDerivator.privateKey(seed: seed)
let privateMasterKeyVersion = KeyVersion(network: network, keyAccessControl: .`private`).wrappedValue
let privateMasterKeyAttributes = MasterKeyAttributes(accessControl: .`private`, version: privateMasterKeyVersion)
let serializedPrivateMasterKey = try keySerializer.serializedKey(extendedKey: privateMasterKey, attributes: privateMasterKeyAttributes)
let encodedPrivateMasterKey = serializedKeyCoder.encode(serializedKey: serializedPrivateMasterKey)
// e.g. xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi

let publicMasterKeyDerivator: PublicMasterKeyDerivating = PublicMasterKeyDerivator()
let publicMasterKey = try publicMasterKeyDerivator.publicKey(privateKey: privateMasterKey)
let publicMasterKeyVersion = KeyVersion(network: network, keyAccessControl: .`public`).wrappedValue
let publicMasterKeyAttributes = MasterKeyAttributes(accessControl: .`public`, version: publicMasterKeyVersion)
let serializedPublicMasterKey = try keySerializer.serializedKey(extendedKey: publicMasterKey, attributes: publicMasterKeyAttributes)
let encodedPublicMasterKey = serializedKeyCoder.encode(serializedKey: serializedPublicMasterKey)
// e.g. xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8
```

Find out more by exploring the public API (e.g. for child key derivation), and by looking through the [tests](Tests/BIP32Tests).

## License

`BIP32` is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for more information.

## Acknowledgments

In developing `BIP32`, [KevinVitale](https://github.com/KevinVitale)'s [WalletKit](https://github.com/KevinVitale/WalletKit) has been used as a reference implementation. In addition, `BIP32` depends on [krzyzanowskim](https://github.com/krzyzanowskim)'s [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift), [GigaBitcoin](https://github.com/GigaBitcoin)'s [secp256k1.swift](https://github.com/GigaBitcoin/secp256k1.swift) and [attaswift](https://github.com/attaswift)'s [BigInt](https://github.com/attaswift/BigInt).

## Donations

If you've found this software useful, please consider making a small contribution to one of these crypto addresses:

```
XNAV: xNTYqoQDzsiB5Cff9Wpt65AgZxYkt1GFy7KwuDafqRU2bcAZqoZUW4Q9TZ9QRHSy8cPsM5ALkJasizJCmqSNP9CosxrF2RbKHuDz5uJVUBcKJfvnb3RZaWygr8Bhuqbpc3DsgfB3ayc
XMR: 49jzT7Amu9BCvc5q3PGiUzWXEBQTLQw68a2KvBFTMs7SHjeWgrSKgxs69ycFWQupyw9fpR6tdT8Hp5h3KksrBG9m4c8aXiG
BTC: bc1q7hehfmnq67x5k7vz0cnc75qyflkqtxe2avjkyw
ETH (ERC-20) & BNB (BEP-20): 0xe08e383B4042749dE5Df57d48c57A690DC322b8d
```
