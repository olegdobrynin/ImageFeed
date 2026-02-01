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
            guard let token = newValue else { return }
            KeychainWrapper.standard.set(token, forKey: tokenKey)
        }
    }
}

