//
//  MediaInfo.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

public enum MediaInfo: CaseIterable {

    case genres
    case country
    case year
    case duration
    case videoDetails
    case audioDetails
    case subtitleDetails
    case userRating

    @ViewBuilder public func label(item: any KodiItem) -> some View {
        switch self {
        case .genres:
            label(title: item.genre.joined(separator: "・"), icon: "lightbulb")
        case .duration:
            label(title: Utils.secondsToTimeString(seconds: item.duration), icon: "clock")
        case .videoDetails:
            switch item.media {
            case .movie, .episode, .musicVideo:
                label(title: item.streamDetails.videoLabel, icon: "display")
            default:
                EmptyView()
            }
        case .audioDetails:
            switch item.media {
            case .movie, .episode, .musicVideo:
                label(title: item.streamDetails.audioLabel, icon: "hifispeaker.2")
            default:
                EmptyView()
            }
        case .subtitleDetails:
            switch item.media {
            case .movie, .episode, .musicVideo:
                label(title: item.streamDetails.subtitleLabel, icon: "captions.bubble")
            default:
                EmptyView()
            }
        case .userRating:
            switch item.media {
            case .movie, .tvshow, .season, .episode, .musicVideo:
                label(view: MediaInfo.ratingToStars(rating: item.userRating), icon: "star.fill")
            default:
                EmptyView()
            }
        case .country:
            switch item {
            case let movie as Video.Details.Movie:
                label(title: movie.country.joined(separator: "・"), icon: "flag")
            default:
                EmptyView()
            }
        case .year:
            switch item {
            case let movie as Video.Details.Movie:
                label(title: movie.year.description, icon: "calendar")
            default:
                EmptyView()
            }
        }
    }
}

extension MediaInfo {
    
    @ViewBuilder func label(title: String, icon: String) -> some View {
        if !title.isEmpty {
            Label(title, systemImage: icon)
        }
    }
    
    @ViewBuilder func label<T: View>(view: T, icon: String) -> some View {
        Label(
            title: { view },
            icon: { Image(systemName: icon) }
        )
    }
}

extension MediaInfo {
    static public func labels(item: any KodiItem, labels: [MediaInfo]) -> some View {
        ForEach(labels, id: \.self) { label in
            label.label(item: item)
        }
    }
}

extension MediaInfo {

    // MARK: Rating to Stars

    /// View a KodiItem rating with stars
    /// - Parameters:
    ///   - rating: The rating
    /// - Returns: A view with stars
    static public func ratingToStars(rating: Int) -> some View {
        return HStack(spacing: 0) {
            ForEach(1..<6, id: \.self) { number in
                Image(systemName: image(number: number))
                    .foregroundStyle(number * 2 <= rating + 1 ? .primary : .secondary)
            }
        }

        /// Convert a number to an SF image String
        /// - Parameter number: The number
        /// - Returns: The SF image as String
        func image(number: Int) -> String {
            if number * 2 <= rating {
                return "star.fill"
            } else if number * 2 == rating + 1 {
                return "star.leadinghalf.filled"
            } else {
                return "star"
            }
        }
    }
}
