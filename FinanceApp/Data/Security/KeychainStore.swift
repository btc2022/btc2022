import Foundation
import Security

protocol SecretStore { func save(_ data: Data, for key: String) throws; func data(for key: String) throws -> Data? }

enum KeychainError: Error { case unhandled(OSStatus) }

struct KeychainStore: SecretStore {
    private let service = Bundle.main.bundleIdentifier ?? "FinanceApp"
    func save(_ data: Data, for key: String) throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service, kSecAttrAccount as String: key]
        SecItemDelete(query as CFDictionary)
        var insertion = query
        insertion[kSecValueData as String] = data
        insertion[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        let status = SecItemAdd(insertion as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandled(status) }
    }
    func data(for key: String) throws -> Data? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service, kSecAttrAccount as String: key,
            kSecReturnData as String: true, kSecMatchLimit as String: kSecMatchLimitOne]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw KeychainError.unhandled(status) }
        return result as? Data
    }
}
