//
//  KodiArt.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

#if os(macOS)
public typealias SWIFTImage = NSImage
#else
public typealias SWIFTImage = UIImage
#endif

/// All Kodi art related items
public enum KodiArt {
    case poster
    case fanart
}

// MARK: Public Kodi Art Views

public extension KodiArt {

    /// SwiftUI `View` for any Kodi art by it's internal file location
    struct Art: View {
        /// The Art Item
        private let art: ArtItem
        /// Init the `View`
        /// - Parameters:
        ///   - file: The internal file location of the art
        ///   - ratio: The ratio of the art
        public init(file: String, ratio: Ratio = .poster) {
            self.art = ArtItem(
                id: file,
                /// A 'dummy' item, can be anything...
                item: Audio.Details.Song(),
                ratio: ratio,
                file: file
            )
        }
        /// The body of the View
        public var body: some View {
            LoadView(art: art)
        }
    }

    /// SwiftUI `View` for a ``KodiItem`` poster
    struct Poster: View {
        /// The Art Item
        let art: ArtItem
        /// Init the `View`
        /// - Parameter item: The ``KodiItem``
        public init(item: (any KodiItem)) {
            var art = ArtItem(item: item, ratio: .poster)
            switch item {
            case let season as Video.Details.Season:
                /// Use the thumb of the season
                art.file = season.art.seasonPoster
                art.ratio = .poster
            case let episode as Video.Details.Episode:
                /// Use the thumb of the season
                art.file = episode.art.seasonPoster
                art.ratio = .poster
            case let artist as Audio.Details.Artist:
                art.file = artist.poster
                art.ratio = .square
            case let song as Audio.Details.Song:
                /// Use the thumb of the album
                art.file = song.art.albumThumb
                art.ratio = .square
            default:
                art.file = item.poster
                art.ratio = .poster
            }
            art.error = item.poster.isEmpty ? .noURL : .none
            art.id = art.error == .none ? art.id : UUID().uuidString
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
        let art: ArtItem
        /// Init the `View`
        public init(item: (any KodiItem)) {
            var art = ArtItem(item: item, ratio: .fanart, file: item.fanart)
            /// Finetune the ArtItem
            art.error = item.fanart.isEmpty ? .noURL : .none
            art.id = art.error == .none ? item.fanart : UUID().uuidString
            self.art = art
        }
        /// The body of the View
        public var body: some View {
            LoadView(art: art)
        }
    }
}

// MARK: Internal Kodi Art Views

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
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The Image Loader model
        @State private var imageLoader = ImageLoader()
        /// The Art Item
        let art: ArtItem
        /// The body of the `View`
        var body: some View {
            VStack {
                if let image = imageLoader.kodiImage {
                    ArtView(image: image)
                } else {
                    Image(systemName: "scribble")
                }
            }
            .task {
                var artItem = art
                imageLoader.host = kodi.host
                /// Optionally hide episode fanart (thumbs)
                switch art.item {
                case let episode as Video.Details.Episode:
                    if art.ratio == .fanart &&
                        episode.playcount == 0 &&
                        !(kodi.getKodiSetting(id: .videolibraryShowUwatchedPlots).list.value.contains(2)) {
                        artItem.error = .hidden
                    }
                default:
                    break
                }
                /// Download the art from the Kodi host
                try? await imageLoader.getImage(art: artItem)
            }
            .id(art.id)
        }
    }
}

// MARK: Kodi Art Observable class

extension KodiArt {

    /// Observable class for loading Kodi art
    @Observable
    final class ImageLoader {
        /// The final Image
        var kodiImage: Image?
        /// The NSImage or UIImage
        var image: SWIFTImage?
        /// The current host
        var host: HostItem?
        /// Get art from the Kodi host
        /// - Parameters:
        ///   - item: The Art Item
        func getImage (art: ArtItem) async throws {
            do {
                guard
                    let host,
                    art.error != .hidden
                else {
                    throw ArtError.hidden
                }
                guard !art.file.isEmpty, !art.file.starts(with: "image://Default") else {
                    throw ArtError.noURL
                }
                guard let url = URL(string: Files.getFullPath(host: host, file: art.file, type: .art)) else {
                    throw ArtError.badURL
                }
                /// Check if in cache
                if let cachedImage = KodiArt.cache.object(forKey: url.absoluteString as NSString) {
                    image = cachedImage
                } else {
                    let request = URLRequest(url: url)
                    let (data, response) = try await JSON.urlSession.data(for: request)
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
                /// Create a allback image
                kodiImage = await createFallback(item: art.item, ratio: art.ratio, error: error)
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
    @MainActor
    static func createFallback(item: any KodiItem, ratio: Ratio, error: Error) -> Image? {
        let fallback = ImageRenderer(content: Fallback(item: item, ratio: ratio, error: error))
        if let cgImage = fallback.cgImage {
            return Image(cgImage, scale: 1, label: Text("Image")).resizable()
        }
        return nil
    }

    /// SwiftUI `View` for a fallback image
    struct Fallback: View {
        /// The ``KodiItem``
        let item: any KodiItem
        /// The ratio of the ``KodiArt``
        let ratio: Ratio
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
            .frame(width: ratio.size.width, height: ratio.size.height)
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

// MARK: Bits and pieces

extension KodiArt {

    /// The ratio of the art
    public enum Ratio {
        /// Poster art with 3:2 ratio
        case poster
        /// Fanart art with 16:9 ratio
        case fanart
        /// Square art with 1:1 ratio
        case square
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
}

extension KodiArt {

    /// The Error message we can expect when retreiving art
    enum ArtError: Error {
        /// Not an error
        case none
        /// Bad request
        case badRequest
        /// Unsupprted image
        case unsupportedImage
        /// Bad URL
        case badURL
        /// No URL
        case noURL
        /// Art is hidden on request
        case hidden
    }
}

extension KodiArt {

    /// Structure of and Art Item
    struct ArtItem {
        /// The ID of the art
        var id: String = UUID().uuidString
        /// The complete ``KodiItem``
        var item: (any KodiItem)
        /// The ratio of the art
        var ratio: Ratio
        /// The internal file location of the art
        var file: String = ""
        /// The optional error when retreiving the art
        var error: ArtError = .none
    }
}

extension KodiArt {

    /// Store art in a memory cache
    public static let cache = NSCache<NSString, SWIFTImage>()
}
