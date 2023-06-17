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
extension String {

    /// Make a string lowercase and without funny accents
    /// - Returns: A simplified String
    func simplifyString() -> String {
        folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }

}
