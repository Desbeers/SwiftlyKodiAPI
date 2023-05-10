//
//  Debug.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// Debug messages
public func logger(_ string: String) {
#if DEBUG
    print("\(Thread.isMainThread ? "👀 " : "⺓ ")\(string) \(Date())")
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
