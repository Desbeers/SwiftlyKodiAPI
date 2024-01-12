//
//  Hosts.swift
//  Komodio (shared)
//
//  © 2024 Nick Berendsen
//

import Foundation

/// Helper functions for Host Items
public extension KodiConnector {
    
    /// Bool if the host is online
    /// - Parameter host: The ``HostItem``
    /// - Returns: True when online; else false
    func hostIsOnline(_ host: HostItem) -> Bool {
        let host = bonjourHosts.first { $0.name == host.name }
        return host == nil ? false : true
    }
    
    /// Bool if the host is the current selected host
    /// - Parameter host: The ``HostItem``
    /// - Returns: True when the host is selected; else false
    func hostIsSelected(_ host: HostItem) -> Bool {
        return self.host.ip == host.ip
    }

    /// Get the optional configured hosts
    /// - Returns: All configured hosts
    func getConfiguredHosts() -> [HostItem]? {
        if !configuredHosts.isEmpty {
            return configuredHosts.sorted { hostIsSelected($0) && !hostIsSelected($1) }
        }
        return nil
    }

    /// Get the optional new hosts
    /// - Returns: All new hosts
    func getNewHosts() -> [HostItem]? {
        let configuredHosts = configuredHosts.map { $0.ip }
        let newHosts = bonjourHosts.filter { !configuredHosts.contains(($0.ip)) }
        return newHosts.isEmpty ? nil : newHosts
    }
}
