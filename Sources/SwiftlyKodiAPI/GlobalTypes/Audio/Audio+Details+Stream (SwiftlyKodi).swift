//
//  Audio+Details+Stream.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Audio.Details {

    /// Stream details (SwiftlyKodi Type)
    struct Stream: KodiItem {

        /// # Public Init

        public init(
            media: Library.Media = .stream,
            station: String = "",
            description: String = "",
            title: String = "",
            subtitle: String = "",
            poster: String = "",
            playcount: Int = 0,
            lastPlayed: String = "",
            userRating: Int = 0,
            fanart: String = "",
            file: String = ""
        ) {
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

        /// The ID of the stream
        public var id: String { station }
        /// The Kodi ID of the stream
        public var kodiID: Library.ID = 0
        /// The search string
        public var search: String { title }
        /// Calculated sort title
        public var sortByTitle: String { title }
        /// The details of the stream
        public var details: String = "Stream"
        public var duration: Int = 0
        /// The resume position of the stream
        /// - Note: Not in use but needed by protocol
        public var resume = Video.Resume()
        /// The date the stream is added
        /// - Note: Not in use but needed by protocol
        public var dateAdded: String = ""
        /// The release year of the item
        /// - Note: Not in use but needed by protocol
        public var year: Int = 0
        /// The genre of the item
        /// - Note: Not in use but needed by protocol
        public var genre: [String] = []

        /// # Audio.Details.Stream

        /// The type of media
        public var media: Library.Media
        public var station: String
        public var description: String
        public var title: String
        /// The subtitle of the stream
        public var subtitle: String
        /// The poster of the stream
        public var poster: String
        public var playcount: Int
        public var lastPlayed: String
        public var rating: Double = 0
        public var userRating: Int
        public var fanart: String
        /// The location of the media file
        public var file: String
    }
}

// MARK: Stream extensions

extension Audio.Details.Stream {

    /// Play an audio stream
    public func play() {
        Task {
            /// Make sure party mode is off
            if await Player.getProperties(playerID: .audio).partymode {
                Player.setPartyMode(playerID: .audio)
            }
            Playlist.clear(playlistID: .audio)
            await Playlist.add(stream: self)
            Player.open(playlistID: .audio)
        }
    }
}
