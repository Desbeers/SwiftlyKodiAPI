//
//  KodiArt.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// MARK: Kodi Art Views

/// SwiftUI Views for Kodi art (SwiftlyKodi Type)
///
/// It will give the most fitting art for the ``KodiItem``
///
/// For example, when asking for a season poster; you will get the ``Media/Artwork/seasonPoster``
public enum KodiArt {
    /// Poster art with 3:2 ratio
    case poster
    /// Fanart art with 16:9 ratio
    case fanart
    /// Square art with 1:1 ratio
    case square
}

extension KodiArt {

    /// Create a fallback image
    struct Fallback: View {
        let item: any KodiItem
        let art: KodiArt
        init(item: any KodiItem, art: KodiArt) {
            self.item = item
            self.art = art
        }
        var size: CGSize {
            switch art {
            case .poster:
                return CGSize(width: 1000, height: 1500)
            case .fanart:
                return CGSize(width: 1920, height: 1080)
            case .square:
                return CGSize(width: 1000, height: 1000)
            }
        }
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.mint.gradient)
                VStack {
                    item.media.label
                        .font(.system(size: 100))
                        .minimumScaleFactor(0.1)
                        .foregroundColor(.secondary)
                        .padding()
                    Text(item.title)
                        .font(.system(size: 200))
                        .minimumScaleFactor(0.1)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .frame(width: size.width, height: size.height)
        }
    }
}

public extension KodiArt {

    /// SwiftUI View for a ``KodiItem`` poster
    struct Poster: View {
        /// The ``KodiItem``
        let item: any KodiItem
        /// Init the View
        public init(item: any KodiItem) {
            self.item = item
        }
        /// The body of the View
        public var body: some View {
            switch item {
            case let episode as Video.Details.Episode:
                Art(item: item, file: episode.art.seasonPoster, art: .fanart)
            case let artist as Audio.Details.Artist:
                Art(item: item, file: artist.poster, art: .square)
            default:
                Art(item: item, file: item.poster, art: .poster)
            }
        }
    }

    /// SwiftUI View for a ``KodiItem`` fanart
    struct Fanart: View {
        /// The ``KodiItem``
        let item: any KodiItem
        /// Init the View
        public init(item: any KodiItem) {
            self.item = item
        }
        /// The body of the View
        public var body: some View {
            Art(item: item, file: item.fanart, art: .fanart)
        }
    }

    /// Any art passed as an internal Kodi string
    ///
    /// - Note:It will be converted to a 'full' url string
    private struct Art: View {
        let item: any KodiItem
        let file: String
        let art: KodiArt
        public init(item: any KodiItem, file: String, art: KodiArt) {
            self.item = item
            self.file = file
            self.art = art
        }
        var body: some View {
            Group {
                if file.isEmpty {
                    createFallback()
                } else {
                    AsyncImage(
                        url: URL(string: Files.getFullPath(file: file, type: .art)),
                        transaction: Transaction(animation: .easeInOut(duration: 0.1))
                    ) { phase in
                        switch phase {
                        case .empty:
                            EmptyView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .transition(.opacity)
                        case .failure:
                            createFallback()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        @MainActor func createFallback() -> some View {
            Group {
                let fallback = ImageRenderer(content: Fallback(item: item, art: art))
                if let cgImage = fallback.cgImage {
                    Image(cgImage, scale: 1, label: Text("test")).resizable()
                }
                EmptyView()
            }
        }
    }
}
