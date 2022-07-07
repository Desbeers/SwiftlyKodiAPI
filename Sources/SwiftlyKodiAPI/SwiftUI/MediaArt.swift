//
//  MediaArt.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// SwiftUI Views for Kodi art
public enum MediaArt {
    /// Just a placeholder
}

public extension MediaArt {
    
    /// Art of the now playing item
    struct Poster: View {
        @EnvironmentObject var kodi: KodiConnector
        let item: any KodiItem
        public init(item: any KodiItem) {
            self.item = item
        }
        public var body: some View {
            AsyncImage(url: URL(string: Files.getFullPath(file: item.poster, type: .art))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.black
            }
        }
    }
}

//public extension MediaArt {
//    
//    /// Art of the now playing item
//    struct NowPlaying: View {
//        @EnvironmentObject var kodi: KodiConnector
//        public init() { }
//        public var body: some View {
//            AsyncImage(url: URL(string: kodi.currentItem.poster)) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 400, height: 225)
//            } placeholder: {
//                Color.black
//                    .frame(width: 400, height: 225)
//            }
//        }
//    }
//}
