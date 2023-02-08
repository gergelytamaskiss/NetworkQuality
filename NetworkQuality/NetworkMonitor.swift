//
//  NetworkMonitor.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 02. 08..
//

import Network
import CoreWLAN

class NetworkMonitor: ObservableObject {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "Monitor")
    
    var connectionStatus = NWPath.Status.unsatisfied
    var connectionType = NWInterface.InterfaceType.other
    var SSIDName: String?
    var isExpensive = false
    var isConstrained = false
    
    init() {
        
        monitor.pathUpdateHandler = { path in
            self.connectionStatus = path.status
            
            let connectionTypes: [NWInterface.InterfaceType] = [.wifi, .wiredEthernet, .cellular]
            self.connectionType = connectionTypes.first(where: path.usesInterfaceType) ?? .other
            
            if (self.connectionType == .wifi) {
                self.SSIDName = CWWiFiClient.shared().interface()!.ssid()!
            } else {
                self.SSIDName = nil
            }
            
            self.isExpensive = path.isExpensive
            self.isConstrained = path.isConstrained
            
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }

        monitor.start(queue: queue)
    }
    
    
}
