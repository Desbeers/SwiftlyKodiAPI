//
//  Video+Resume.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Video {

    /// The resume details of a video item
    public struct Resume: Codable, Hashable {
        
        public var position: Double = 0
        public var total: Double = 0

    }
}
