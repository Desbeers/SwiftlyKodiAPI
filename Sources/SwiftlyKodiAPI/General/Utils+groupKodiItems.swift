//
//  Utils+groupKodiItems.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Utils {
    // swiftlint: disable:next function_body_length
    static func groupKodiItems(items: [any KodiItem], sorting: SwiftlyKodiAPI.List.Sort) -> ScrollCollection<AnyKodiItem> {

        let items = items.anykodiItem()

        switch sorting.method {

        case .year:
            return Dictionary(grouping: items) { item in
                var sectionLabel = "Unknown"
                var indexLabel = "Unknown"
                if item.item.year != 0 {
                    let decade = (item.item.year / 10) * 10
                    sectionLabel = "Between \(decade) and \(decade + 9)"
                    indexLabel = String(decade)
                }
                return ScrollCollectionHeader(
                    sectionLabel: sectionLabel,
                    indexLabel: indexLabel,
                    sort: indexLabel
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort))
        case .dateAdded:
            return Dictionary(grouping: items) { item in
                let decade = Int(item.item.dateAdded.prefix(4)) ?? 0
                var sectionLabel = "Unknown"
                var indexLabel = "Unknown"
                if decade != 0 {
                    sectionLabel = "Added in \(decade)"
                    indexLabel = String(decade)
                }
                return ScrollCollectionHeader(
                    sectionLabel: sectionLabel,
                    indexLabel: indexLabel,
                    sort: indexLabel
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort, order: .reverse))
        case .userRating:
            return Dictionary(grouping: items) { item in
                var sectionLabel = "No rating"
                var indexLabel = "􀕧"
                if item.item.userRating != 0 {
                    sectionLabel = "\(item.item.userRating) " + String(repeating: "*", count: item.item.userRating)
                    indexLabel = String(item.item.userRating)
                }
                return ScrollCollectionHeader(
                    sectionLabel: sectionLabel,
                    indexLabel: indexLabel,
                    sort: String(item.item.userRating)
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort, order: .reverse))
        case .duration:
            return Dictionary(grouping: items) { item in
                let hour = (item.item.duration / 3600)
                let sectionLabel = hour == 0 ? "Less than \(hour + 1) hour" : "Between \(hour) and \(hour + 1) hours"
                let indexLabel = "\(hour)-\(hour + 1)"
                return ScrollCollectionHeader(
                    sectionLabel: sectionLabel,
                    indexLabel: indexLabel,
                    sort: String(hour)
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort))

        case .genre:
            /// Find all genres
            let genres = Set(items.flatMap { $0.item.genre })
            /// Create a new dictionary
            var dict = ScrollCollection<AnyKodiItem>()
            /// Add the items
            for genre in genres {
                let items = items.filter { $0.item.genre.contains(genre) }
                if !items.isEmpty {
                    let key = ScrollCollectionHeader(
                        sectionLabel: genre,
                        indexLabel: genre.prefix(1).uppercased(),
                        sort: genre
                    )
                    dict.append((key, items))
                }
            }
            return dict.sorted(using: KeyPathComparator(\.0.sort))

        case .media:
            return Dictionary(grouping: items) { item in
                ScrollCollectionHeader(
                    sectionLabel: item.item.media.plural,
                    indexLabel: "",
                    sort: item.item.media.plural
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort))
        default:
            return Dictionary(grouping: items) { item in
                let title = item.item.sortByTitle.trimmingCharacters(in: .punctuationCharacters)
                let firstLetter = title.prefix(1).uppercased()
                var sectionLabel = firstLetter
                var indexLabel = firstLetter

                if Int(firstLetter) != nil {
                    sectionLabel = "0-9"
                    indexLabel = "0"
                }
                return ScrollCollectionHeader(
                    sectionLabel: sectionLabel,
                    indexLabel: indexLabel,
                    sort: indexLabel
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort))
        }
    }
}
