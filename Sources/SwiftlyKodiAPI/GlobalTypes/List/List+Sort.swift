//
//  List+Sort.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension List {

    // MARK: List.Sort

    /// The sort fields for JSON requests (Global Kodi Type)
    public struct Sort: Codable, Equatable, Hashable {
        /// Init the sort order
        public init(
            id: String = "ID",
            method: List.Sort.Method = .title,
            order: List.Sort.Order = .ascending,
            useartistsortname: Bool = true
        ) {
            self.id = id
            self.method = method
            self.order = order
            self.useartistsortname = useartistsortname
        }
        /// The ID of the sort
        /// - Note: Not in use for KodiAPI but for internal sorting of ``KodiItem``s
        public var id: String
        /// The method
        public var method: Method
        /// The order
        public var order: Order
        /// Use artist sort name
        public var useartistsortname: Bool
    }
}
