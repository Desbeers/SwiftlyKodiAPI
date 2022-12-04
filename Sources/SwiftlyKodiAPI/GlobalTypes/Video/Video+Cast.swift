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
        
        /// # Calculated variables
        
        public var id: Int { order }
        
        /// # Video.Cast
        
        /// The name of the actor
        public var name: String = ""
        /// The order in the cast list
        public var order: Int = 0
        /// The role of the actor
        public var role: String = ""
        /// The optional thumbnail of the actor
        public var thumbnail: String? = nil
        
        /// # Coding keys
        
        enum CodingKeys: String, CodingKey {
            /// The keys for this Actor Item
            case name, order, role, thumbnail
        }
    }
}
