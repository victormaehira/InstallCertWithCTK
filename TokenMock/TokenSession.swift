//
//  TokenSession.swift
//  TokenMock
//
//  Created by victor.maehira on 26/03/26.
//

import CryptoTokenKit
import Foundation

/// Sessão mínima: sem HSM, operações criptográficas falham ou são recusadas em `supports`.
final class TokenSession: TKTokenSession, TKTokenSessionDelegate {

    override init(token: TKToken) {
        super.init(token: token)
        delegate = self
    }

    // MARK: - TKTokenSessionDelegate

    func tokenSession(
        _ session: TKTokenSession,
        supports operation: TKTokenOperation,
        keyObjectID: TKToken.ObjectID,
        algorithm: TKTokenKeyAlgorithm
    ) -> Bool {
        // Quando ligares o HSM, aqui podes filtrar por `keyObjectID` / algoritmo.
        false
    }

    func tokenSession(
        _ session: TKTokenSession,
        sign dataToSign: Data,
        keyObjectID: TKToken.ObjectID,
        algorithm: TKTokenKeyAlgorithm
    ) throws -> Data {
        throw TokenSessionError.notImplemented
    }

    func tokenSession(
        _ session: TKTokenSession,
        decrypt ciphertext: Data,
        keyObjectID: TKToken.ObjectID,
        algorithm: TKTokenKeyAlgorithm
    ) throws -> Data {
        throw TokenSessionError.notImplemented
    }

    func tokenSession(
        _ session: TKTokenSession,
        performKeyExchange otherPartyPublicKeyData: Data,
        keyObjectID objectID: TKToken.ObjectID,
        algorithm: TKTokenKeyAlgorithm,
        parameters: TKTokenKeyExchangeParameters
    ) throws -> Data {
        throw TokenSessionError.notImplemented
    }

    func tokenSession(
        _ session: TKTokenSession,
        beginAuthFor operation: TKTokenOperation,
        constraint: Any
    ) throws -> TKTokenAuthOperation {
        throw TokenSessionError.notImplemented
    }
}

// MARK: -

private enum TokenSessionError: LocalizedError {
    case notImplemented

    var errorDescription: String? {
        "Operação ainda não implementada (HSM não ligado)."
    }
}
