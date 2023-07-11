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
        case none
        case noKodiItem
        case badRequest
        case unsupportedImage
        case badURL
        case noURL
        case hidden
    }
}

extension KodiArt {

    /// Structure of and Art Item
    struct Item {
        var item: (any KodiItem)?
        var art: KodiArt
        var id: String = "AAAfallback"
        var file: String = ""
        var error: ArtError = .none
        var fallback: Image?
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
        /// The Art Item
        let art: Item
        /// Init the `View`
        public init(item: (any KodiItem)?, fallback: Image? = nil) {
            var art = Item(item: item, art: .poster, fallback: fallback)
            if let item {
                art.error = item.file.isEmpty ? .noURL : .none
                art.id = item.fanart
                art.file = item.fanart
                switch item {

                case let season as Video.Details.Season:
                    /// Use the thumb of the season
                    art.file = season.art.seasonPoster
                    art.art = .poster
                case let episode as Video.Details.Episode:
                    /// Use the thumb of the season
                    art.file = episode.art.seasonPoster
                    art.art = .poster
                case let artist as Audio.Details.Artist:
                    art.file = artist.poster
                    art.art = .square
                case let song as Audio.Details.Song:
                    /// Use the thumb of the album
                    art.file = song.art.albumThumb
                    art.art = .square
                default:
                    art.file = item.poster
                    art.art = .poster
                }
            } else  {
                art.error = .noKodiItem
            }
            art.id = art.file
            self.art = art
        }
        /// The body of the View
        public var body: some View {
            LoadView(art: art)
        }
    }

    /// SwiftUI `View` for a ``KodiItem`` fanart
    struct Fanart: View {
        /// The Art Item
        let art: Item
        /// Init the `View`
        public init(item: (any KodiItem)?, fallback: Image? = nil) {
            var art = Item(item: item, art: .fanart, fallback: fallback)
            if let item {
                art.error = item.fanart.isEmpty ? .noURL : .none
                art.id = item.fanart
                art.file = item.fanart
                switch item {
                case let episode as Video.Details.Episode:
                    if !KodiConnector.shared.getKodiSetting(id: .videolibraryShowuUwatchedPlots).list.contains(2) &&
                        episode.playcount == 0 {
                        art.error = .hidden
                        /// Give hidden art its own ID so it can be replaced if the playcount is changed
                        art.id += "\(item.playcount)"
                    }
                default:
                    break
                }
            } else  {
                art.error = .noKodiItem
            }
            art.id = art.error == .none ? art.id : "BBBfallback"
            self.art = art
        }
        /// The body of the View
        public var body: some View {
            LoadView(art: art)
        }
    }
}

extension KodiArt {

    /// SwiftUI `View` for the final Kodi art
    struct ArtView: View {
        /// The Art image
        let image: Image
        /// The body of the `View`
        var body: some View {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .transition(.opacity)
        }
    }
}

extension KodiArt {

    /// SwiftUI `View` for loading any kind of Kodi art
    struct LoadView: View {
        /// The Image Loader model
        @StateObject private var imageLoader = ImageLoader()
        /// The Art Item
        let art: Item
        /// The body of the `View`
        var body: some View {
            VStack {
                if let image = imageLoader.kodiImage {
                    ArtView(image: image)
                } else {
                    ProgressView()
                }
            }
            .task {
                if art.error != .none, let fallback = art.fallback {
                    imageLoader.kodiImage = fallback
                } else {
                    /// Download the art from the Kodi host
                    do {
                        try await imageLoader.getImage(art: art)
                    } catch {
                        /// Ignore; this should not happen...
                    }
                }
            }
            .id(art.id)
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
        ///   - item: The Art Item
        func getImage (art: Item) async throws {
            do {
                guard art.error != .hidden else {
                    throw ArtError.hidden
                }
                guard !art.file.isEmpty, !art.file.starts(with: "image://Default") else {
                    throw ArtError.noURL
                }
                guard let url = URL(string: Files.getFullPath(file: art.file, type: .art)) else {
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
                if let item = art.item {
                    kodiImage = createFallback(kodiItem: item, art: art.art, error: error)
                }
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
