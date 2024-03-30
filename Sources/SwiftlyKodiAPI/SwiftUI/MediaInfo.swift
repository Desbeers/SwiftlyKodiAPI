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

    @ViewBuilder 
    public func label(item: any KodiItem) -> some View {
        switch self {
        case .genres:
            Genres(item: item)
        case .duration:
            Duration(item: item)
        case .videoDetails:
            switch item.media {
            case .movie, .episode, .musicVideo:
                VideoDetails(item: item)
            default:
                EmptyView()
            }
        case .audioDetails:
            switch item.media {
            case .movie, .episode, .musicVideo:
                AudioDetails(item: item)
            default:
                EmptyView()
            }
        case .subtitleDetails:
            switch item.media {
            case .movie, .episode, .musicVideo:
                SubtitleDetails(item: item)
            default:
                EmptyView()
            }
        case .userRating:
            switch item.media {
            case .movie, .tvshow, .season, .episode, .musicVideo:
                UserRating(item: item)
            default:
                EmptyView()
            }
        case .country:
            switch item {
            case let movie as Video.Details.Movie:
                County(country: movie.country)
            default:
                EmptyView()
            }
        case .year:
            switch item {
            case let movie as Video.Details.Movie:
                Year(year: movie.year)
            default:
                EmptyView()
            }
        }
    }
}


extension MediaInfo {

    struct Genres: View {

        let item: any KodiItem

        var body: some View {
            if !item.genre.isEmpty {
                Label(
                    title: {
                        Text("\(item.genre.joined(separator: "・"))")
                    },
                    icon: {
                        Image(systemName: "lightbulb")
                    }
                )
            }
        }
    }

    struct Duration: View {

        let item: any KodiItem

        var body: some View {
            Label(
                title: {
                    Text("\(Utils.secondsToTimeString(seconds: item.duration))")
                },
                icon: {
                    Image(systemName: "clock")
                }
            )
        }
    }

    struct VideoDetails: View {

        let item: any KodiItem

        var body: some View {
            Label(
                title: {
                    Text("\(item.streamDetails.videoLabel)")
                },
                icon: {
                    Image(systemName: "display")
                }
            )
        }
    }

    struct AudioDetails: View {

        let item: any KodiItem

        var body: some View {
            Label(
                title: {
                    Text("\(item.streamDetails.audioLabel)")
                },
                icon: {
                    Image(systemName: "hifispeaker.2")
                }
            )
        }
    }

    struct SubtitleDetails: View {

        let item: any KodiItem

        var body: some View {
            if !item.streamDetails.subtitle.isEmpty {
                Label(
                    title: {
                        Text("\(item.streamDetails.subtitleLabel)")
                    },
                    icon: {
                        Image(systemName: "captions.bubble")
                    }
                )
            }
        }
    }

    struct UserRating: View {

        let item: any KodiItem

        var body: some View {
            Label(
                title: {
                    MediaInfo.ratingToStars(rating: item.userRating)
                },
                icon: {
                    Image(systemName: "star.fill")
                }
            )
        }
    }

    struct County: View {

        let country: [String]

        var body: some View {
            Label(
                title: {
                    Text("\(country.joined(separator: "・"))")
                },
                icon: {
                    Image(systemName: "flag")
                }
            )
        }
    }

    struct Year: View {

        let year: Int

        var body: some View {
            Label(
                title: {
                    Text("\(year.description)")
                },
                icon: {
                    Image(systemName: "calendar")
                }
            )
        }
    }
}

extension MediaInfo {
    static public func labels(item: any KodiItem, labels: [MediaInfo]) -> some View {
        //HStack {
            ForEach(labels, id: \.self) { label in
                label.label(item: item)
            }
        //}
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
