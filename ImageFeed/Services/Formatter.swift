//
//  File.swift
//  ImageFeed
//
//  Created by olegg on 05.02.2026.
//


import Foundation

extension ISO8601DateFormatter {
    static let imageFeedISO8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
extension DateFormatter {
    static let imageFeedDisplayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

