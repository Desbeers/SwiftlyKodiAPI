//
//  MediaArt.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

public struct MediaArt {
    /// Just a placeholder
}

public extension MediaArt {
    
    /// Art of the now playing item
    struct NowPlaying: View {
        @EnvironmentObject var kodi: KodiConnector
        public init() { }
        public var body: some View {
            AsyncImage(url: URL(string: kodi.currentItem.poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 225)
            } placeholder: {
                Color.black
                    .frame(width: 400, height: 225)
            }
        }
    }
}