//
//  Cache.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

/// Get and set structs to the cache directory
public enum Cache {

    /// Get a struct from the cache
    /// - Parameters:
    ///   - key: The name of the item in the cache
    ///   - as: The struct to use for decoding
    ///   - root: Get it from the root folder; if false, it will get it from the Host IP folder
    /// - Returns: decoded cache item
    public static func get<T: Codable>(key: String, as: T.Type, root: Bool = false) -> T? {
        let file = self.path(for: key, root: root)
        guard let data = try? Data(contentsOf: file) else {
            return nil
        }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            logger("Can't decode '\(key)'")
            return nil
        }
        logger("Loaded '\(key)' from cache")
        return decoded
    }

    /// Save a struct into the cache
    /// - Parameters:
    ///   - key: The name for the item in the cache
    ///   - object:Tthe struct to save
    ///   - root: Store it in the root folder; if false, it will store it in the Host IP folder
    /// - Throws: an error if it can't be saved
    public static func set<T: Codable>(key: String, object: T, root: Bool = false) throws {
        let file = self.path(for: key, root: root)
        let archivedValue = try JSONEncoder().encode(object)
        try archivedValue.write(to: file)
        logger("Stored '\(key)' in cache")
    }

    /// Delete a struct from the cache
    /// - Parameters:
    ///   - key: The name for the item in the cache
    ///   - root: Delete it in the root folder; if false, it will delete it from the Host IP folder
    /// - Throws: an error if it can't be saved
    public static func delete(key: String, root: Bool = false) throws {
        let file = self.path(for: key, root: root)
        let fileManager = FileManager.default
        /// Check if file exists
        if fileManager.fileExists(atPath: file.path()) {
            /// Delete the file
            try fileManager.removeItem(atPath: file.path())
            logger("Deleted '\(key)' from cache")
        } else {
            logger("'\(key)' does not exist in the cache")
        }
    }

    /// Get the path to the cache directory
    /// - Parameters:
    ///   - key: The name of the cache item
    ///   - root: Get the root path or the library host path
    /// - Returns: A full ``URL`` to the cache direcory
    static private func path(for key: String, root: Bool) -> URL {
        let manager = FileManager.default
        let rootFolderURL = manager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        var nestedFolderURL = rootFolderURL[0]
        if !root {
            nestedFolderURL = rootFolderURL[0].appendingPathComponent(KodiConnector.shared.host.ip)
            if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
                do {
                    try manager.createDirectory(
                        at: nestedFolderURL,
                        withIntermediateDirectories: false,
                        attributes: nil
                    )
                } catch {
                    logger("Error creating directory")
                }
            }
        }
        return nestedFolderURL.appendingPathComponent(key + ".cache")
    }
}
