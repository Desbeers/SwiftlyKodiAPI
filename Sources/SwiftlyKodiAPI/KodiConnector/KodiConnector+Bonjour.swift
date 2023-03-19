//
//  KodiConnector+Bonjour.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//
import Foundation
import Network

// MARK: Bonjour

extension KodiConnector {

    /// Start Bonjour to find Kodi hosts
    func startBonjour() {
        logger("Starting Bonjour")
        let browser = NWBrowser(for: .bonjour(type: "_xbmc-jsonrpc._tcp", domain: "local."), using: NWParameters())
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                // Restart Bonjour if it loses its connection.
                if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_DefunctConnection)) {
                    logger("Browser failed with \(error), restarting")
                    browser.cancel()
                    self.startBonjour()
                } else {
                    logger("Browser failed with \(error), stopping")
                    browser.cancel()
                }
            default:
                break
            }
        }

        /// The delegate to update the list of bonjour Kodi's when Bonjour found a change
        browser.browseResultsChangedHandler = { _, changes in
            for change in changes {
                switch change {
                case .identical:
                    break
                case .added(let result):
                    self.addHost(host: result)
                case .removed(let result):
                    self.removeHost(host: result)
                default:
                    break
                }
            }
        }
        /// Start browsing and ask for updates on the main queue.
        browser.start(queue: .main)
    }

    /// Stop Bonjour
    func stopBonjour() {
        logger("Stopping Bonjour")
        browser?.cancel()
        bonjourHosts = []
    }

    /// Add a new Kodi host to the Bonjour list
    /// - Parameter host: The host to add
    func addHost(host: NWBrowser.Result) {
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = host.endpoint {
            /// We want the IP V4 address
            let params = NWParameters.tcp
            // swiftlint:disable force_cast
            // swiftlint:disable force_unwrapping
            let ip = params.defaultProtocolStack.internetProtocol! as! NWProtocolIP.Options
            // swiftlint:enable force_cast
            // swiftlint:enable force_unwrapping
            ip.version = .v4
            let connection = NWConnection(to: host.endpoint, using: params)
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    if
                        let innerEndpoint = connection.currentPath?.remoteEndpoint,
                        case let .hostPort(host, port) = innerEndpoint,
                        let ip = String(describing: host).split(separator: "%").first
                    {
                        /// Add the host the the Bonjour list
                        self.bonjourHosts.append(BonjourHost(name: name, ip: ip.description, port: Int(port.rawValue)))
                        /// Set the current host as 'online' if this is the new one
                        if self.host.ip == ip {
                            Task {
                                await self.setStatus(.online)
                            }
                        }
                        logger("'\(name)' is online")
                        /// Cancel the connection because it was only made to get the IP address
                        connection.cancel()
                    }
                default:
                    break
                }
            }
            connection.start(queue: .main)
        }
    }

    /// Remove a Kodi host from the Bonjour list
    /// - Parameter host: The host to remove
    func removeHost(host: NWBrowser.Result) {
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = host.endpoint {
            bonjourHosts.removeAll { $0.name == name }
            logger("'\(name)' is offline")
            /// Check if the removed Kodi is the active Kodi and act on it
            if self.status != .offline, self.bonjourHosts.first(where: { $0.name == name }) != nil {
                Task {
                    await self.setStatus(.offline)
                }
            }
        }
    }
}

public extension KodiConnector {

    /// Struct for a Kodi host found by the Bonjour browser
    struct BonjourHost: Equatable, Hashable, Identifiable {
        /// The ID of the bonjour host
        public var id: String { ip }
        /// The name of the Kodi service
        /// - Note: This is the name set in Kodi
        public var name: String
        /// The IP V4 address of the host
        public var ip: String
        /// The port of the host
        public var port: Int
        /// Bool if thIs this host is new or not
        public var new: Bool {
            return KodiConnector.shared.configuredHosts.contains { $0.ip == ip } ? false : true
        }
    }
}
