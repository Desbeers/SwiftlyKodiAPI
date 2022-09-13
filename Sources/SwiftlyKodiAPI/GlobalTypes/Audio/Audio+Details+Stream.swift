//
//  Audio+Details+Stream.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    /// Stream details
    struct Stream: KodiItem {
        /// Init the audio stream
        public init(id: Int = 1, media: Library.Media = .stream, station: String = "", description: String = "", title: String = "", subtitle: String = "", poster: String = "", playcount: Int = 0, lastPlayed: String = "", userRating: Int = 0, fanart: String = "", file: String = "") {
            self.id = id
            self.media = media
            self.station = station
            self.description = description
            self.title = title
            self.subtitle = subtitle
            self.poster = poster
            self.playcount = playcount
            self.lastPlayed = lastPlayed
            self.userRating = userRating
            self.fanart = fanart
            self.file = file
        }
        
        /// # Calculated variables
        
        /// The search string
        public var search: String { title }
        public var sortByTitle: String { title }
        public var details: String = "Stream"
        
        /// Not in use but needed by protocol
        public var resume = Video.Resume()
        
        /// # Audio.Details.Stream
        ///
        public var id: Int
        public var media: Library.Media
        public var station: String
        public var description: String
        public var title: String
        public var subtitle: String
        public var poster: String
        public var playcount: Int
        public var lastPlayed: String
        public var userRating: Int
        public var fanart: String
        public var file: String
    }
}

// MARK: Stream extensions

extension Audio.Details.Stream {
    
    /// Play an audio stream
    public func play() {
        Task {
            /// Make sure party mode is off
            if KodiPlayer.shared.properties.partymode {
                Player.setPartyMode(playerID: .audio)
            }
            Playlist.clear(playlistID: .audio)
            await Playlist.add(stream: self)
            Player.open(playlistID: .audio)
        }
    }
}
