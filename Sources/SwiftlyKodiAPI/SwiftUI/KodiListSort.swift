//
//  KodiListSort.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyStructCache
import OSLog

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
        @Environment(KodiConnector.self) private var kodi
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
            .onChange(of: sorting) { _, item in
                if let index = kodi.listSortSettings.firstIndex(where: { $0.id == sorting.id }) {
                    kodi.listSortSettings[index] = item
                } else {
                    kodi.listSortSettings.append(item)
                }
                KodiListSort.saveSortSettings(host: kodi.host, settings: kodi.listSortSettings)
            }
            .labelsHidden()
        }
    }
}

extension KodiListSort {

    /// Get all the `List Sort` settings
    /// - Parameter host: The curren ``HostItem``
    /// - Returns: The stored List Sort settings
    static func getAllSortSettings(host: HostItem) -> [SwiftlyKodiAPI.List.Sort] {
        Logger.library.info("Get all the sorting settings")
        if let settings = try? Cache.get(key: "ListSort", as: [SwiftlyKodiAPI.List.Sort].self, folder: host.ip) {
            return settings
        }
        /// No settings found
        return []
    }

    /// Save the `List Sort` settings to the cache
    /// - Parameter host: The curren ``HostItem``
    /// - Parameter settings: All the current List Sort settings
    static func saveSortSettings(host: HostItem, settings: [SwiftlyKodiAPI.List.Sort]) {
        do {
            try Cache.set(key: "ListSort", object: settings, folder: host.ip)
        } catch {
            Logger.library.error("Error saving ListSort settings")
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
