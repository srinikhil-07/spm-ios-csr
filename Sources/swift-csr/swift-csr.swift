//
//  File.swift
//  
//
//  Created by Nikhil on 3/13/20.
//

import Foundation
import spm_ios_csr
import Security
import os

public class GenerateCSR {
    enum CSRGenerationError: Error {
        case keyExportError
        case csrGenerationError
        case keyGenerationError
    }
    var publicAppTag = String()
    var privateAppTag = String()
    var publicKeyLabel = String()
    var privateKeyLabel = String()
    public init() {}
    public func generateCSR(withOptins options: [String:String]) throws -> String {
        var publicKey: SecKey?
        var privateKey: SecKey?
        let publicKeyAttr: [CFString: Any] = [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: publicAppTag.data(using: String.Encoding.utf8) ?? Data(),
            kSecAttrLabel: publicKeyLabel
        ]
        let privateKeyAttr: [CFString: Any] = [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: privateAppTag.data(using: String.Encoding.utf8) ?? Data(),
            kSecAttrLabel: privateKeyLabel
        ]
        let keyPairAttr: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits: 2048,
            kSecPublicKeyAttrs: publicKeyAttr,
            kSecPrivateKeyAttrs: privateKeyAttr
        ]
        deleteKeyPairInKeychain()
        _ = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)
        if let publicKeyValue = publicKey {
            //let publicKeyData = SecKeyCopyExternalRepresentation(publicKeyValue, nil)
            var publicKeyData : CFData?
            var exportStatus : OSStatus
            #if os(iOS) || os(watchOS)
                exportStatus = SecKeyCopyExternalRepresentation(publicKeyValue, nil)
            #elseif os(OSX)
            exportStatus = SecItemExport(publicKeyValue, SecExternalFormat.formatBSAFE, [], nil, &publicKeyData)
            #endif
        guard exportStatus == errSecSuccess else {
                NSLog("Public key export failed with error: %@",String(describing: exportStatus))
                throw CSRGenerationError.keyExportError
            }
            let sccsr: SCCSR = SCCSR()
            sccsr.commonName = options["commonName"]
            sccsr.organizationName = options["organizationName"]
            sccsr.countryName = options["countryName"]
            if let csr = sccsr.build(publicKeyData as Data?, privateKey: privateKey) {
                let csrString = csr.base64EncodedString(options: [])
                return csrString
            } else {
                throw CSRGenerationError.csrGenerationError
            }
        } else {
            throw CSRGenerationError.keyGenerationError
        }
    }
    ///Method to search if the keypair exists and delete them
    public func deleteKeyPairInKeychain() {
        var deleteQuery : [String: Any] = [kSecClass as String: kSecClassKey,
                                           kSecAttrApplicationTag as String: privateAppTag.data(using: String.Encoding.utf8) ?? Data(),
                                           kSecAttrKeyType as String: kSecAttrKeyTypeRSA]
        _ = SecItemDelete(deleteQuery as CFDictionary)
        deleteQuery = [kSecClass as String: kSecClassKey,
                                           kSecAttrApplicationTag as String: publicAppTag.data(using: String.Encoding.utf8) ?? Data(),
                                           kSecAttrKeyType as String: kSecAttrKeyTypeRSA]
        _ = SecItemDelete(deleteQuery as CFDictionary)
    }
}
