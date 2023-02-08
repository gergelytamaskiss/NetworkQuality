//
//  InterfaceData.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 02. 08..
//

import Foundation
import Network

struct InterfaceData {
    
    let connectionStatus: NWPath.Status
    let interfaceType: [NWInterface]
    let SSIDName: String?
    let isExpensive: Bool
    let isConstrained: Bool
//    let internalIPAddress: String
//    let externalIPAddress: String
    
}
