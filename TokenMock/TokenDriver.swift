//
//  TokenDriver.swift
//  TokenMock
//
//  Created by victor.maehira on 26/03/26.
//

import CryptoTokenKit
import Foundation

/// Driver CTK genérico (não smart card). O `NSExtensionPrincipalClass` no Info.plist deve apontar para esta classe
/// (ex.: `$(PRODUCT_MODULE_NAME).TokenDriver`).
final class TokenDriver: TKTokenDriver, TKTokenDriverDelegate {

    override init() {
        super.init()
        delegate = self
        print(">TokenDriver.init")
    }

    // MARK: - TKTokenDriverDelegate

    /// O sistema chama isto depois de `addTokenConfiguration` na app host. Smart card drivers **não** implementam este método.
    func tokenDriver(_ driver: TKTokenDriver, tokenFor configuration: TKToken.Configuration) throws -> TKToken {
        Token(tokenDriver: driver, instanceID: configuration.instanceID)
    }
}
