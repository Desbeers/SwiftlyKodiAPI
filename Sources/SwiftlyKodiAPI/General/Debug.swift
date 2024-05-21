//
//  Debug.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// Messages for the Logger
public extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    static var connection: Logger {
        Logger(subsystem: subsystem, category: "Kodi Connection")
    }
    static var kodiAPI: Logger {
        Logger(subsystem: subsystem, category: "Kodi API")
    }
    static var library: Logger {
        Logger(subsystem: subsystem, category: "Kodi Library")
    }
    static var player: Logger {
        Logger(subsystem: subsystem, category: "Kodi Player")
    }
    static var notice: Logger {
        Logger(subsystem: subsystem, category: "Kodi Notice")
    }
    static var client: Logger {
        Logger(subsystem: subsystem, category: "Kodi Client")
    }
}

/// Debug messages
public func logger(_ string: String) {
#if DEBUG
    Logger.client.debug("\(Thread.isMainThread ? "👀 " : "⺓ ")\(string) \(Date())")
#endif
}

/// Print raw JSON to the console
func debugJsonResponse(data: Data) {
    do {
        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            print(jsonResult)
        }
    } catch let error {
        logger(error.localizedDescription)
    }
}

func measureElapsedTime(_ operation: () throws -> Void) throws -> Double {
    let startTime = DispatchTime.now()
    try operation()
    let endTime = DispatchTime.now()

    let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds

    return Double(elapsedTime) / 1_000_000_000
}
