//
//  KodiListSort.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI Views for sorting of Kodi items (SwiftlyKodi Type)
public enum KodiListSort {
    // Just a namespace here
}

public extension KodiListSort {

    // MARK: PickerView

    /// Sort a list: Two pickers to select the method and order
    ///
    /// For `tvOS` it will be Buttons for the method instead of a picker because it might be too many items
    struct PickerView: View {
        /// The current sorting
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
            Group {
#if os(macOS)
                HStack {
                    Picker(selection: $sorting.method, label: Text("Sort method")) {
                        ForEach(SwiftlyKodiAPI.List.Sort.getMethods(media: media), id: \.rawValue) { method in
                            Text(method.displayLabel)
                                .tag(method)
                        }
                    }
                    sortOrder
                }
#endif

#if os(tvOS)
                VStack {
                    ForEach(SwiftlyKodiAPI.List.Sort.getMethods(media: media), id: \.rawValue) { method in
                        Button(action: {
                            sorting.method = method
                        }, label: {
                            Text(method.displayLabel)
                                .frame(width: 600)
                                .fontWeight(sorting.method == method ? .heavy : .regular)
                        })
                    }
                    sortOrder
                }
#endif

#if os(iOS)
                VStack {
                    ForEach(SwiftlyKodiAPI.List.Sort.getMethods(media: media), id: \.rawValue) { method in
                        Button(action: {
                            sorting.method = method
                        }, label: {
                            Text(method.displayLabel)
                                .fontWeight(sorting.method == method ? .heavy : .regular)
                        })
                        .padding()
                    }
                    sortOrder
                }
                .padding()
#endif
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

        /// The sort order of the View
        var sortOrder: some View {
            Picker(selection: $sorting.order, label: Text("Sort order")) {
                ForEach(SwiftlyKodiAPI.List.Sort.Order.allCases, id: \.rawValue) { order in
                    Text(order.displayLabel(method: sorting.method))
                        .tag(order)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

extension KodiListSort {

    /// Get all the `List Sort` settings
    /// - Returns: The stored List Sort settings
    static func getAllSortSettings() -> [SwiftlyKodiAPI.List.Sort] {
        logger("Get ListSort settings")
        if let settings = Cache.get(key: "ListSort", as: [SwiftlyKodiAPI.List.Sort].self, root: true) {
            return settings
        }
        /// No settings found
        return []
    }

    /// Save the `List Sort` settings to the cache
    /// - Parameter settings: All the current List Sort settings
    static func saveSortSettings(settings: [SwiftlyKodiAPI.List.Sort]) {
        do {
            try Cache.set(key: "ListSort", object: settings, root: true)
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
