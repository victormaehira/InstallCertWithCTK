//
//  Token.swift
//  TokenMock
//
//  Created by victor.maehira on 26/03/26.
//

import CryptoTokenKit
import Foundation

/// Instância de token CTK genérico. Criada pelo `TokenDriver.tokenDriver(_:tokenFor:)`.
final class Token: TKToken, TKTokenDelegate {

    override init(tokenDriver: TKTokenDriver, instanceID: TKToken.InstanceID) {
        super.init(tokenDriver: tokenDriver, instanceID: instanceID)
        delegate = self
    }

    // MARK: - TKTokenDelegate

    func createSession(_ token: TKToken) throws -> TKTokenSession {
        TokenSession(token: token)
    }

    func token(_ token: TKToken, terminateSession session: TKTokenSession) {
        // Opcional: libertar recursos se `TokenSession` mantiver estado (HSM, caches, etc.).
    }
}
