//
//  Utils.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

/// Utility functions (SwiftlyKodi Type)
public enum Utils {
    // Just a namespace
}

public extension Utils {

    /// Convert a `Date` to a Kodi date string
    /// - Parameter date: The `Date`
    /// - Returns: A string with the date
    static func kodiDateFromSwiftDate(_ date: Date) -> String {
        kodiDateFormatter.string(from: date)
    }

    /// Convert a Kodi date string to a `Date`
    /// - Parameter date: The Kodi date string
    /// - Returns: A Swift `Date`
    static func swiftDateFromKodiDate(_ date: String) -> Date {
        kodiDateFormatter.date(from: date) ?? Date(timeIntervalSinceReferenceDate: 0)
    }

    /// The `DateFormatter` for a Kodi date
    private static var kodiDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        /// It turns out that the DateFormatter takes the target date into account, not our current time, which is not what we want so set the the zone
        dateFormatter.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        return dateFormatter
    }
}

public extension Utils {

    /// Convert 'seconds' to a formatted time string
    /// - Parameters:
    ///   - seconds: The seconds
    ///   - style: The time format
    /// - Returns: A formatted String
    static func secondsToTimeString(seconds: Int, style: DateComponentsFormatter.UnitsStyle = .brief) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = style
        return formatter.string(from: TimeInterval(Double(seconds))) ?? ""
    }
}

extension String {

    /// Make a string lowercase and without funny accents
    /// - Returns: A simplified String
    func simplifyString() -> String {
        folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }

}

extension Bundle {

    /// The name of the client
    var clientName: String {
            return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Kodi Client"
    }
}
