//
//  KodiArt.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

#if os(macOS)
typealias SWIFTImage = NSImage
#else
typealias SWIFTImage = UIImage
#endif

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

    /// The size for fallback images
    var size: CGSize {
        switch self {
        case .poster:
            return CGSize(width: 1000, height: 1500)
        case .fanart:
            return CGSize(width: 1920, height: 1080)
        case .square:
            return CGSize(width: 1000, height: 1000)
        }
    }
}

extension KodiArt {

    /// The Error message we can expect
    enum ArtError: Error {
        case badRequest
        case unsupportedImage
        case badURL
        case noURL
        case hidden
    }
}

extension KodiArt {

    /// Store art in a memory cache
    private static let cache = NSCache<NSString, SWIFTImage>()
}

// MARK: Kodi Art Views

public extension KodiArt {

    /// SwiftUI `View` for a ``KodiItem`` poster
    struct Poster: View {
        /// The ``KodiItem``
        let item: any KodiItem
        /// Init the `View`
        public init(item: any KodiItem) {
            self.item = item
        }
        /// The body of the View
        public var body: some View {
            switch item {
            case let season as Video.Details.Season:
                /// Use the thumb of the season
                LoadView(item: item, file: season.art.seasonPoster, art: .poster)
            case let episode as Video.Details.Episode:
                /// Use the thumb of the season
                LoadView(item: item, file: episode.art.seasonPoster, art: .poster)
            case let artist as Audio.Details.Artist:
                LoadView(item: item, file: artist.poster, art: .square)
            case let song as Audio.Details.Song:
                /// Use the thumb of the album
                LoadView(item: item, file: song.art.albumThumb, art: .square)
            default:
                LoadView(item: item, file: item.poster, art: .poster)
            }
        }
    }

    /// SwiftUI `View` for a ``KodiItem`` fanart
    struct Fanart: View {
        /// The ``KodiItem``
        let item: any KodiItem
        /// Init the `View`
        public init(item: any KodiItem) {
            self.item = item
        }
        /// The body of the View
        public var body: some View {
            switch item {
            case let episode as Video.Details.Episode:
                if !KodiConnector.shared.getKodiSetting(id: .videolibraryShowuUwatchedPlots).list.contains(2) &&
                    episode.playcount == 0 {
                    LoadView(item: item, file: item.fanart, art: .fanart, hidden: true)
                } else {
                    LoadView(item: item, file: item.fanart, art: .fanart)
                }
            default:
                LoadView(item: item, file: item.fanart, art: .fanart)
            }
        }
    }
}

extension KodiArt {

    /// SwiftUI `View` for loading any kind of Kodi art
    struct LoadView: View {
        /// The Image Loader model
        @StateObject private var imageLoader = ImageLoader()
        /// The ``KodiItem``
        let item: any KodiItem
        /// The file of the art
        let file: String
        /// The kind of art
        let art: KodiArt
        /// Should the art be hidden as per Kodo setting
        var hidden: Bool = false
        /// The body of the `View`
        var body: some View {
            VStack {
                if let image = imageLoader.kodiImage {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .transition(.opacity)
                } else {
                    ProgressView()
                }
            }
            .task {
                /// Hide episode thumb if set so by Kodi for unwatched episodes
                if hidden {
                    imageLoader.kodiImage = createFallback(kodiItem: item, art: .fanart, error: ArtError.hidden)
                } else {
                    /// Download the art from the Kodi host
                    do {
                        try await imageLoader.getImage(item: item, file: file, art: art)
                    } catch {
                        /// Ignore; this should not happen...
                    }
                }
            }
            /// Give hidden art its own ID so it can be replaced if the playcount is changed
            .id(hidden ? "\(file)\(item.playcount)" : "\(file)")
        }
    }
}

// MARK: Kodi Art Observable class

extension KodiArt {

    /// Observable class for loading Kodi art
    @MainActor class ImageLoader: ObservableObject {
        /// The final Image
        @Published var kodiImage: Image?
        /// The NSImage or UIImage
        var image: SWIFTImage?

        /// Get art from the Kodi host
        /// - Parameters:
        ///   - item: The ``KodiItem``
        ///   - file: The file of the art
        ///   - art: The kind of art
        func getImage (item: any KodiItem, file: String, art: KodiArt) async throws {
            do {
                guard !file.isEmpty else {
                    throw ArtError.noURL
                }
                guard let url = URL(string: Files.getFullPath(file: file, type: .art)) else {
                    throw ArtError.badURL
                }
                /// Check if in cache
                if let cachedImage = KodiArt.cache.object(forKey: url.absoluteString as NSString) {
                    image = cachedImage
                } else {
                    let request = URLRequest(url: url)
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForRequest = 1
                    configuration.timeoutIntervalForResource = 1
                    let session = URLSession(configuration: configuration)
                    let (data, response) = try await session.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw ArtError.badRequest
                    }
                    guard let image = SWIFTImage(data: data) else {
                        throw ArtError.unsupportedImage
                    }
                    /// Store it in the cache
                    KodiArt.cache.setObject(image, forKey: url.absoluteString as NSString)
                    self.image = image

                }
                if let image {
#if os(macOS)
                    kodiImage = Image(nsImage: image)
#else
                    kodiImage = Image(uiImage: image)
#endif
                }
            } catch {
                kodiImage = createFallback(kodiItem: item, art: art, error: error)
            }
        }
    }


}

// MARK: Kodi Art create Fallback

extension KodiArt {

    /// Create a fallback image
    /// - Parameters:
    ///   - kodiIitem: The ``KodiItem``
    ///   - art: The kind of ``KodiArt``
    ///   - error: The Error that made us create a fallback
    @MainActor static func createFallback(kodiItem: any KodiItem, art: KodiArt, error: Error) -> Image? {
        let fallback = ImageRenderer(content: Fallback(item: kodiItem, art: art, error: error))
        if let cgImage = fallback.cgImage {
            return Image(cgImage, scale: 1, label: Text("Image")).resizable()
        }
        return nil
    }

    /// SwiftUI `View` for a fallback image
    struct Fallback: View {
        /// The ``KodiItem``
        let item: any KodiItem
        /// The kind of ``KodiArt``
        let art: KodiArt
        /// The Error that made us create a fallback
        let error: Error
        /// The calculated label
        var label: (title: String, color: Color, error: String?) {
            switch error {
            case ArtError.noURL:
                /// Not a real Error, the item has no art defined
                return (item.title, .mint, nil)
            case ArtError.hidden:
                /// Not a real Error, the item is hidden a per Kodi setting
                return (item.title, .orange, "Art is hidden for unwatched episodes")
            case URLError.timedOut:
                return (item.title, .red, "The loading of the image timed-out")
            default:
                return (item.title, .gray, "\(error)")
            }
        }

        /// The body of the `View`
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(label.color.gradient)
                VStack {
                    item.media.label
                        .font(.system(size: 100))
                        .foregroundStyle(.secondary)
                        .padding()
                    Text(label.title)
                        .font(.system(size: 200))
                        .foregroundStyle(.primary)
                        .lineLimit(correctLineLimit)
                        .padding()
                    if let error = label.error {
                        Text(error)
                            .foregroundStyle(.tertiary)
                            .font(.system(size: 100))
                            .padding()
                    }
                }
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .allowsTightening(true)
                .padding()
            }
            .frame(width: art.size.width, height: art.size.height)
        }

        /// Calculate the line limit
        ///
        /// Make sure a 'one word' line will not be wrapped
        var correctLineLimit: Int {
            let wordcount = label.title.split(separator: " ")
            return wordcount.count > 1 ? 2 : 1
        }
    }

}
