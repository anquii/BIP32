import Foundation
import XCTest
@testable import BIP32

final class KeyAddressDerivatorTests: XCTestCase {
    private func sut() -> KeyAddressDerivator {
        .init()
    }

    func testGivenVectorHex_WhenDerivateAddress_ThenEqualVectorAddress() throws {
        let publicKey = Data(hex: KeyAddressTestVector.hexEncodedPublicKey)
        let address = sut().address(publicKey: publicKey, version: KeyAddressTestVector.version)
        XCTAssertEqual(address, KeyAddressTestVector.address)
    }
}
