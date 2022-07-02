//
//  Video+Cast.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Video {

    /// The cast of a video item
    public struct Cast: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        /// The name of the actor
        public var name: String = ""
        /// The order in the cast list
        public var order: Int = 0
        /// The role of the actor
        public var role: String = ""
        /// The optional thumbnail of the actor
        public var thumbnail: String? = ""
        
        
        public var icon: String {
            if let icon = thumbnail, !icon.isEmpty {
                return Files.getFullPath(file: icon, type: .art)
            }
            return ""
        }
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            /// The keys for this Actor Item
            case name, order, role, thumbnail
        }
    }
}
