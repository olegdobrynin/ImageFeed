//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by olegg on 07.02.2026.
//


import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
        ProfileService.shared.exitProfileService()
        ProfileImageService.shared.logoutProfileImageService()
        ImagesListService.shared.exitImagesListService()
        OAuth2TokenStorage.shared.clearToken()
        
        NotificationCenter.default.post(name: .userDidLogout, object: nil)
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            
            records.forEach { record in WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
