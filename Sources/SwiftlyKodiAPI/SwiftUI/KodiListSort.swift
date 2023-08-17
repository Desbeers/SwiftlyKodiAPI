//
//  KodiListSort.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyStructCache

/// SwiftUI Views for sorting of Kodi items (SwiftlyKodi Type)
public enum KodiListSort {
    // Just a namespace here
}

public extension KodiListSort {

    // MARK: SortPickerView

    /// Sort a list
    struct SortPickerView: View {
        /// The current sorting option
        @Binding var sorting: SwiftlyKodiAPI.List.Sort
        /// The kind of media
        let media: Library.Media
        /// The KodiConnector model
        @EnvironmentObject private var kodi: KodiConnector
        /// Init the View
        public init(sorting: Binding<List.Sort>, media: Library.Media) {
            self._sorting = sorting
            self.media = media
        }

        // MARK: Body of the View

        /// The body of the View
        public var body: some View {
            Picker(selection: $sorting, label: Text("Sort method")) {
                ForEach(List.Sort.Option.getMethods(media: media), id: \.rawValue) { option in
                    Text(option.label)
                        .tag(List.Sort(id: sorting.id, method: option.sorting.method, order: option.sorting.order))
                }
            }
            .onChange(of: sorting) { item in
                if let index = kodi.listSortSettings.firstIndex(where: { $0.id == sorting.id }) {
                    kodi.listSortSettings[index] = item
                } else {
                    kodi.listSortSettings.append(item)
                }
                KodiListSort.saveSortSettings(settings: kodi.listSortSettings)
            }
            .labelsHidden()
        }
    }
}

extension KodiListSort {

    /// Get all the `List Sort` settings
    /// - Returns: The stored List Sort settings
    static func getAllSortSettings() -> [SwiftlyKodiAPI.List.Sort] {
        logger("Get ListSort settings")
        if let settings = try? Cache.get(key: "ListSort", as: [SwiftlyKodiAPI.List.Sort].self, folder: KodiConnector.shared.host.ip) {
            return settings
        }
        /// No settings found
        return []
    }

    /// Save the `List Sort` settings to the cache
    /// - Parameter settings: All the current List Sort settings
    static func saveSortSettings(settings: [SwiftlyKodiAPI.List.Sort]) {
        do {
            try Cache.set(key: "ListSort", object: settings, folder: KodiConnector.shared.host.ip)
        } catch {
            logger("Error saving ListSort settings")
        }
    }

    /// Get the `List Sort` settings for a View
    /// - Parameter sortID: The ID of the sorting
    public static func getSortSetting(sortID: String) -> SwiftlyKodiAPI.List.Sort {
        if let sorting = KodiConnector.shared.listSortSettings.first(where: { $0.id == sortID }) {
            return sorting
        }
        return SwiftlyKodiAPI.List.Sort(id: sortID)
    }
}
