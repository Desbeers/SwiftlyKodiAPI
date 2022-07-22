//
//  List+Item+File.swift
//  
//
//  Created by Nick Berendsen on 15/07/2022.
//

import Foundation

public extension List.Item {
    
    /// File item (SwiftlyKodi Type)
    struct File: Codable, Hashable {
        public var label: String
        public var file: String
        public var fileType: FileType
        public var type: Library.Media
        public var id: Int?
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case label
            case file
            case fileType = "filetype"
            case type
            case id
        }
        /// FileType
        public enum FileType: String, Codable, Hashable {
            case directory
            case file
        }
    }
}
