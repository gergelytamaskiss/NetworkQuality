//
//  NetworkQualityTest+DefaultValues.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 04. 14..
//

import Foundation

extension NetworkQualityTest {
    
    public var wrappedConnectionStatus: String {
        connectionStatus ?? "Unkown"
    }
    
    public var wrappedInterfaceType: String {
        if (interfaceType == "Ethernet") {
            return "desktopcomputer"
        } else if (interfaceType == "Wi-Fi") {
            return "wifi"
        }
        return "questionmark.square.dashed"
    }
    
    public var wrappedStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
        
        return dateFormatter.string(from: startDate ?? Date())
    }
    
    public var wrappedDownloadSpeed: String {
        "\(downlinkSpeed / 1_000_000)"
    }
    
    public var wrappedUploadSpeed: String {
        "\(uplinkSpeed / 1_000_000)"
    }
    
    public var wrappedLatency: String {
        let rounded = Double(round(10 * latency) / 10)
        return rounded.description
    }
    
    public var wrappedSSIDName: String {
        ssidName ?? ""
    }
    
    public var duration: String {
        let diffComponents = Calendar.current.dateComponents([.minute, .second], from: startDate ?? Date(), to: endDate ?? Date())
        let minutes = diffComponents.minute
        let seconds = diffComponents.second
        return "\(minutes!):\(seconds!)"
    }
    
    public var wrappedSequential: String {
        runSequentially ? "checkmark.square.fill" : ""
    }
    
    
}
