//
//  List+Filter.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {
    
    /// Filter fields for JSON requests (SwiftlyKodi Type)
    public struct Filter: Codable {
        /// Filter by album ID
        var albumID: Library.id?
        /// Filter by artist ID
        var artistID: Library.id?
        /// The field of the filter
        var field: List.Filter.Field?
        /// The operator of the filter
        var operate: List.Filter.Operator?
        /// The value for the filter
        var value: String?
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case albumID = "albumid"
            case artistID = "artistid"
            case field
            case operate = "operator"
            case value
        }
    }
}
