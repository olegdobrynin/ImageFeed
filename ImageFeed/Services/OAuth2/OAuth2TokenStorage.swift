import Foundation
import SwiftKeychainWrapper


final class OAuth2TokenStorage {

    // MARK: - Singleton

    static let shared = OAuth2TokenStorage()
    private init() {}

    // MARK: - Dependencies

    private let userDefaults = UserDefaults.standard

    // MARK: - Constants

    private let tokenKey = "Auth token"

    // MARK: - Public API

    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
}

// MARK: - LogOut
extension OAuth2TokenStorage {
    func clearToken() {
        KeychainWrapper.standard.removeObject(forKey: tokenKey)
        KeychainWrapper.standard.removeObject(forKey: "refresh_token")
    }
}
