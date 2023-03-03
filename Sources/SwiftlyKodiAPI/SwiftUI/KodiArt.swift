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

    private static let cache = NSCache<NSString, SWIFTImage>()
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
}


extension KodiArt {

    enum NetworkError: Error {
        case badRequest
        case unsupportedImage
        case badUrl
    }

    @MainActor class ImageLoader: ObservableObject {

        @Published var kodiImage: Image?

        var image: SWIFTImage?

        func fetchImage (item: any KodiItem, file: String, art: KodiArt) async throws {
            guard !file.isEmpty, let url = URL(string: Files.getFullPath(file: file, type: .art)) else {
                createFallback(item: item, art: art)
                return
            }
            let request = URLRequest(url: url)
            /// Check if in cache
            if let cachedImage = KodiArt.cache.object(forKey: url.absoluteString as NSString) {
                image = cachedImage
            } else {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    createFallback(item: item, art: art)
                    return
                }
                guard let image = SWIFTImage(data: data) else {
                    createFallback(item: item, art: art)
                    return
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
        }

        private func createFallback(item: any KodiItem, art: KodiArt) {
                let fallback = ImageRenderer(content: Fallback(item: item, art: art))
                if let cgImage = fallback.cgImage {
                    kodiImage = Image(cgImage, scale: 1, label: Text("test")).resizable()
                }
        }
    }

    struct Art: View {
        @StateObject private var imageLoader = ImageLoader()

        let item: any KodiItem
        let file: String
        let art: KodiArt
        public init(item: any KodiItem, file: String, art: KodiArt) {
            self.item = item
            self.file = file
            self.art = art
        }

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
                await downloadImage()
            }
        }

        private func downloadImage() async {
                do {
                    try await imageLoader.fetchImage(item: item, file: file, art: art)
                } catch {
                    /// Ignore
                }
        }
    }
}
