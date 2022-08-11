//
//  KodiConnector+Online.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation
import Network

public extension KodiConnector {
    struct OnlineHost: Equatable {
        public var name: String
        public var ip: String
        public var port: Int
    }
    
    func isOnline(host: HostItem) -> Bool {
        if onlineHosts.first(where: {$0.ip == host.ip}) != nil {
            return true
        }
        return false
    }
    
//    func refreshResults(results: Set<NWBrowser.Result>) {
//        self.onlineHosts = [OnlineHost]()
//        for result in results {
//            if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = result.endpoint {
//
//                //dump(result)
//                //self.onlineHosts.append(OnlineHost(name: name, ip: "\(name).local", port: 9090))
//
//                let params = NWParameters.tcp
//                let ip = params.defaultProtocolStack.internetProtocol! as! NWProtocolIP.Options
//                ip.version = .v4
//
//                let connection = NWConnection(to: result.endpoint, using: params)
//
//                connection.stateUpdateHandler = { state in
//                    switch state {
//                    case .ready:
//                        if let innerEndpoint = connection.currentPath?.remoteEndpoint,
//                           case .hostPort(let host, let port) = innerEndpoint,
//                           let ip = String(describing: host).split(separator: "%").first {
//
//                            self.onlineHosts.append(OnlineHost(name: name, ip: ip.description, port: Int(port.rawValue)))
//
//                            print("Connected to", "\(ip):\(port)") // Here, I have the host/port information
//
//                            //dump(innerEndpoint)
//                            connection.cancel()
//                        }
//                    case .cancelled:
//                        logger("Disconnected")
//                    default:
//                        //connection.cancel()
//                        break
//                    }
//                }
//                connection.start(queue: .main)
//            }
//        }
//    }
//
//    // Show an error if peer discovery fails.
//    func displayBrowseError(_ error: NWError) {
//        var message = "Error \(error)"
//        if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_NoAuth)) {
//            message = "Not allowed to access the network"
//        }
//        logger(message)
//    }

    // Start browsing for services.
    func startBrowsing() {
        // Create parameters, and allow browsing over a peer-to-peer link.
        let parameters = NWParameters()
        //parameters.includePeerToPeer = true

        // Browse for a custom "_tictactoe._tcp" service type.
        let browser = NWBrowser(for: .bonjour(type: "_xbmc-jsonrpc._tcp", domain: "local."), using: parameters)
        self.browser = browser
        browser.stateUpdateHandler = { newState in
            switch newState {
            case .failed(let error):
                // Restart the browser if it loses its connection.
                if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_DefunctConnection)) {
                    print("Browser failed with \(error), restarting")
                    browser.cancel()
                    self.startBrowsing()
                } else {
                    print("Browser failed with \(error), stopping")
                    browser.cancel()
                }
//
                
            default:
                break
            }
        }

        // When the list of discovered endpoints changes, refresh the delegate.
        browser.browseResultsChangedHandler = { results, changes in
//            logger("Result changed")
//
//            //dump(results)
//
//            logger("changes")
//
//            dump(changes)
            
            for change in changes {
                
                switch change {
                    
                case .identical:
                    break
                case .added(let result):
                    self.addHost(host: result)
                case .removed(let result):
                    self.removeHost(host: result)
                case .changed(old: let old, new: let new, flags: let flags):
                    break
                @unknown default:
                    break
                }
                //print(change)
            }
            
            //self.refreshResults(results: browser.browseResults)
        }

        // Start browsing and ask for updates on the main queue.
        browser.start(queue: .main)
    }
    
    func addHost(host: NWBrowser.Result) {
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = host.endpoint {
            let params = NWParameters.tcp
            let ip = params.defaultProtocolStack.internetProtocol! as! NWProtocolIP.Options
            ip.version = .v4

            let connection = NWConnection(to: host.endpoint, using: params)

            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    if let innerEndpoint = connection.currentPath?.remoteEndpoint,
                       case .hostPort(let host, let port) = innerEndpoint,
                       let ip = String(describing: host).split(separator: "%").first {

                        self.onlineHosts.append(OnlineHost(name: name, ip: ip.description, port: Int(port.rawValue)))
                        
                        if self.host.ip == ip {
                            //if self.state == .offline && self.host.ip == ip {
                            Task {
                                await self.setState(.online)
                            }
                        }

                        //print("Connected to", "\(ip):\(port)") // Here, I have the host/port information
                        
                        //dump(innerEndpoint)
                        logger("Added: \(name)")
                        connection.cancel()
                    }
                case .cancelled:
                    break
                default:
                    //connection.cancel()
                    break
                }
            }
            connection.start(queue: .main)
        }
    }
    
    func removeHost(host: NWBrowser.Result) {
        
        if case let NWEndpoint.service(name: name, type: _, domain: _, interface: _) = host.endpoint {
            
            onlineHosts.removeAll(where: {$0.name == name})
            
            if self.state != .offline, let _ = self.onlineHosts.first(where: { $0.name == name}) {
                Task {
                    await self.setState(.offline)
                }
            }
            
            
            
            

            logger("Removed: \(name)")
        }
    }
}
