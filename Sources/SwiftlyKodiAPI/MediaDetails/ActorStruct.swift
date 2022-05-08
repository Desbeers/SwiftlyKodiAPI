//
//  File.swift
//  
//
//  Created by Nick Berendsen on 08/05/2022.
//

import Foundation

/// A struct for an actor that is part of the cast in a movie or TV episode
public struct ActorItem: Codable, Identifiable, Hashable {
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
        return getFilePath(file: thumbnail ?? "", type: .art)
    }
    /// Coding keys
    enum CodingKeys: String, CodingKey {
        /// The keys for this Actor Item
        case name, order, role, thumbnail
    }
}
