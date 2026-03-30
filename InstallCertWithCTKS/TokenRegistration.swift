//
//  TokenRegistration.swift
//  InstallCertWithCTKS
//
//  Created by victor.maehira on 26/03/26.
//

import CryptoTokenKit
import Foundation
import Security

/// Regista o token CTK e associa o certificado (e chave “virtual” derivada do cert) à configuração do token.
enum TokenRegistration {
    /// Coincide com o class-id da extensão no Info.plist.
    private static let tokenDriverClassID = "br.com.certisign.InstallCertWithCTKS.TokenMock"

    /// Identificador estável desta instância de token (por utilizador / “HSM”).
    // private static let tokenInstanceID = "installcert.token.mock.v1".data(using: .utf8)!
    private static let tokenInstanceID: TKToken.InstanceID = "installcert.token.mock.v1"


    private static let certificateObjectID = Data("mock-cert".utf8)
    private static let privateKeyObjectID = Data("mock-key".utf8)

    /// Substitui por DER em Base64 (sem linhas PEM).
    private static let hardcodedCertificateDERBase64 =
    "MIIFfDCCA2SgAwIBAgIIEt6nQ2Ejuz0wDQYJKoZIhvcNAQELBQAwYjELMAkGA1UEBhMCQlIxLTArBgNVBAoTJENlcnRpc2lnbiBDZXJ0aWZpY2Fkb3JhIERpZ2l0YWwgUy5BLjEkMCIGA1UEAxMbQUMgQ2VydGlTaWduIENvcnBvcmF0aXZhIEczMB4XDTI1MTEwOTAzMDAwMFoXDTI2MTEwOTAzMDAwMFowgYoxCzAJBgNVBAYTAkJSMS0wKwYDVQQKDCRDZXJ0aXNpZ24gQ2VydGlmaWNhZG9yYSBEaWdpdGFsIFMuQS4xHDAaBgNVBAMME1ZpY3RvciBZdWppIE1hZWhpcmExLjAsBgkqhkiG9w0BCQEWH3ZpY3Rvci5tYWVoaXJhQGNlcnRpc2lnbi5jb20uYnIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC38o1fQqrgsZz8AhWwCKxgDYE4ia0/sdMvqgHqT0G8n88TbRgZ2kMrc5e9ybVD+TlvmSaeN08EAx5NdB7mGJK/EGvRGlbKRIH0Soi9Eyv6Tvb9SDGod0OikK7YtS50rzkWQx2UVs7tQwOX139hlLXE8dfiL0KJ3/42hsKa/L1ZsoJBTXHleMScOFye1FdNgychP5ICJvWEo/Azz0CxZ9CITfRYpT7LVfFrQPWTGmdIIf7HOuO1YlTZ42gws3g05B5xTfq8KtSHzSIsRkscfmaZVP00o/o097f+gAU5jDC/t9ABDfHQT9PznIQWoR315/D+EVMsHVPbxGB4bg1pBBsvAgMBAAGjggELMIIBBzA6BgNVHREEMzAxoC8GCisGAQQBgjcUAgOgIQwfdmljdG9yLm1hZWhpcmFAY2VydGludHJhLmNvbS5icjAJBgNVHRMEAjAAMB8GA1UdIwQYMBaAFGFwXVXxIdM+YNQGfgQ/ME7pW2lDMGwGA1UdHwRlMGMwYaBfoF2GW2h0dHA6Ly9jZXJ0aXNpZ24tY2EuY2VydGlzaWduLmNvbS5ici9yZXBvc2l0b3Jpby9sY3IvQUNDZXJ0aXNpZ25Db3Jwb3JhdGl2YUczL0xhdGVzdENSTC5jcmwwDgYDVR0PAQH/BAQDAgXgMB8GA1UdJQQYMBYGCCsGAQUFBwMCBgorBgEEAYI3FAICMA0GCSqGSIb3DQEBCwUAA4ICAQCbrURiIPc+nIVatWYsyuZ631y/ziDamb3VzgQJf2gRY0qlAd/vFkanoTkaYRU0GEMeBbxh1Wk2eWUz85ptmr+lPFTYtb6CsVidpyP9QA9Pe6aWmd0vhxgUrWjIOLZmr2IVvmztsmqmWEMXkMU/I/LG3Y2oAJvzdHvieRMRspBw91Fc6mnUvce3OV0+xuqYrhya2dmOnrJx9kpvHPBeWri4qzik3XlpiG/VDvbfdeFnHg9NPbmsMR9hXjINSSHFEddJwaQZZhaL4T9GvEcibi7wAn5rbHyt85oOj0MF3vTqTbPm7TMChTT6HnlSZmzGOlVrUlkT6dxlYqUQvFAPDFQDodu1RKLaF/+KD9Jlsjm0e4QO8CstvIXA9QCQNqzrwoVFrg0Ob4d7WH733OjpiGsOmtRk2FKQfKKFpATTBwrfZ6bJjvKedOC9aD3i+GJoNvlbpTq6XopWci9L8T7NFBO6ubA6ZUkkwR1RMh+p0xXNP5fkWZL1djd0JYz1aO6MbCKspSIFlO+CaXe4gWgOg/GlJ4JgFWw0OEPaVxWzd75uW7XaE4WN/+EyBJ5dtf+4/5P53ZB6F/eAl6Ajan8yOnHPLReQLYMxGmvROBcEYcrysu3X0Oe6gPzJtLm/qdXso0V8tZSdajmy+i3hfQ55Xp67uxKeNxd+v/GimYvJg/33QQ=="

    

    static func registerIfPossible() {
        do {
            try register()
        } catch {
            print("TokenRegistration failed: \(error)")
            NSLog("TokenRegistration failed: \(error)")
        }
    }

    private static func register() throws {
        let derData = try derDataFromBase64(hardcodedCertificateDERBase64)
        guard let certificate = SecCertificateCreateWithData(nil, derData as CFData) else {
            print("RegistrationError.invalidDER")
            throw RegistrationError.invalidDER
        }

        //VALIDAR DER EXIBINDDO COMMON NAME
        // Define a variable to hold the common name
        var commonName: CFString?

        // Call SecCertificateCopyCommonName to get the CN
        let status = SecCertificateCopyCommonName(certificate, &commonName)

        // Check status and cast to String
        if status == errSecSuccess, let name = commonName {
            let cn = name as String
            print("Common Name: \(cn)")
        } else {
            print("Failed to get common name")
        }
        
        let classID = TKTokenDriver.ClassID(tokenDriverClassID)
        guard let driverConfig = TKTokenDriver.Configuration.driverConfigurations[classID] else {
            print("RegistrationError.noDriverConfiguration")
            throw RegistrationError.noDriverConfiguration(classID: tokenDriverClassID)
        }

        guard let certItem = TKTokenKeychainCertificate(
            certificate: certificate,
            objectID: certificateObjectID
        ) else {
            print(" certItem RegistrationError.invalidCertificateItems")
            throw RegistrationError.invalidCertificateItems // adiciona este caso ao teu enum
        }
    
        guard let keyItem = TKTokenKeychainKey(
            certificate: certificate,
            objectID: privateKeyObjectID
        ) else {
            print("keyItem RegistrationError.invalidCertificateItems")
            throw RegistrationError.invalidCertificateItems
        }
        
        print("tokenDriverClassID = " + tokenDriverClassID)
        if driverConfig == nil {
            print("TokenRegistration: driverConfig é nil para classID \(tokenDriverClassID)")
            // ou: print("driverConfig nil", tokenDriverClassID)
        } else {
            print("TokenRegistration: driverConfig é NOT nil para classID \(tokenDriverClassID)")
        }

        print("tokenInstanceID = " + tokenInstanceID)
        let tokenConfiguration = driverConfig.addTokenConfiguration(for: tokenInstanceID)
        print("EXECUTOU driverConfig.addTokenConfiguration")
        
        tokenConfiguration.keychainItems = [certItem, keyItem]
        print("EXECUTOU tokenConfiguration.keychainItems")
        
    }

    private static func derDataFromBase64(_ base64: String) throws -> Data {
        let trimmed = base64
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: " ", with: "")
        guard !trimmed.isEmpty else {
            throw RegistrationError.placeholderCertificate
        }
        guard let data = Data(base64Encoded: trimmed) else {
            throw RegistrationError.invalidBase64
        }
        return data
    }

    enum RegistrationError: LocalizedError {
        case placeholderCertificate
        case invalidBase64
        case invalidDER
        case invalidCertificateItems
        case noDriverConfiguration(classID: String)

        var errorDescription: String? {
            switch self {
            case .placeholderCertificate:
                return "Substitui hardcodedCertificateDERBase64 por um DER em Base64."
            case .invalidBase64:
                return "Base64 inválido."
            case .invalidDER:
                return "SecCertificateCreateWithData falhou (DER inválido?)."
            case .invalidCertificateItems:
                return "Não foi possível criar TKTokenKeychainCertificate ou TKTokenKeychainKey."
            case .noDriverConfiguration(let id):
                return "Sem TKTokenDriver.Configuration para class-id \(id). Extensão embutida/assinada?"
            }
        }
    }
}
