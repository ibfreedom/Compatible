//
//  String+Hub.swift
//  Compatible
//
//  Created by tramp on 2021/4/1.
//

import Foundation
import CommonCrypto
import CryptoKit

extension String: CompatiableValue {}
extension CompatibleWapper where Base == String {
    /// CaseType
    public enum CaseType {
        /// upper case
        case uppercased
        /// lower case
        case lowercased
    }
}

extension CompatibleWapper where Base == String {
    
    /// md5 value of string
    /// - Parameter caseType: CaseType
    /// - Returns: String
    public func md5(_ caseType: CaseType = .uppercased) -> String {
        guard let utf8 = base.cString(using: .utf8) else { return "" }
        var digest = Array<UInt8>.init(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        let len = CC_LONG(utf8.count - 1)
        CC_MD5(utf8, len, &digest)
        return digest.reduce("") { (result, char) -> String in
            switch caseType {
            case .lowercased:
                return result + String.init(format: "%02x", char) 
            case .uppercased:
                return result + String.init(format: "%02X", char)
            }
        }
    }
    
    /// sha1 value of string
    /// - Parameter caseType: CaseType
    /// - Returns: String
    public func sha1(_ caseType: CaseType = .uppercased) -> String {
        guard let utf8 = base.cString(using: .utf8) else { return "" }
        var digest = Array<UInt8>.init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let len = CC_LONG(utf8.count - 1)
        CC_SHA1(utf8, len, &digest)
        return digest.reduce("") { (result, char) -> String in
            switch caseType {
            case .lowercased:
                return result + String.init(format: "%02x", char)
            case .uppercased:
                return result + String.init(format: "%02X", char)
            }
        }
    }
}


