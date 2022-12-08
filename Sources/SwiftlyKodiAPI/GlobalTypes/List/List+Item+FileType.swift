//
//  List+Item+FileType.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension List.Item {

    /// The type of file (SwiftlyKodi Type)
    enum FileType: String, Codable, Hashable {
        /// The file is a directory
        case directory
        /// The file is an actual file
        case file
    }
}
