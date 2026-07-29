import UIKit
import CommonCrypto

enum AESCrypto {
    private static let key = "q8h7j3s64q1iesgp"
    private static let iv = "m4qp29xzf72gqwjg"

    static func encrypt(_ text: String) -> String? {
        guard let data = text.data(using: .utf8) else { return nil }
        return crypt(data: data, operation: CCOperation(kCCEncrypt))?.base64EncodedString()
    }

    static func decrypt(_ base64: String) -> String? {
        guard let data = Data(base64Encoded: base64) else { return nil }
        guard let out = crypt(data: data, operation: CCOperation(kCCDecrypt)) else { return nil }
        return String(data: out, encoding: .utf8)
    }

    private static func crypt(data: Data, operation: CCOperation) -> Data? {
        guard let keyData = key.data(using: .utf8), let ivData = iv.data(using: .utf8) else { return nil }
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData = Data(count: cryptLength)
        var numBytes = 0
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                ivData.withUnsafeBytes { ivBytes in
                    keyData.withUnsafeBytes { keyBytes in
                        CCCrypt(operation,
                                CCAlgorithm(kCCAlgorithmAES),
                                CCOptions(kCCOptionPKCS7Padding),
                                keyBytes.baseAddress, kCCKeySizeAES128,
                                ivBytes.baseAddress,
                                dataBytes.baseAddress, data.count,
                                cryptBytes.baseAddress, cryptLength,
                                &numBytes)
                    }
                }
            }
        }
        guard status == kCCSuccess else { return nil }
        cryptData.removeSubrange(numBytes..<cryptData.count)
        return cryptData
    }
}
