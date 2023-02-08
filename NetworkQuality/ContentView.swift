//
//  ContentView.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 01. 30..
//

import SwiftUI
import Network

struct ContentView: View {
    @EnvironmentObject var network: NetworkMonitor
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDate)]) var networkQualityTests: FetchedResults<NetworkQualityTest>
    
    var body: some View {
        
        VStack {
            HStack{
                Text(verbatim: "Connection Status: \(network.connectionStatus)")
                Text(verbatim: "Connection Type: \(network.connectionType)")
                Text(verbatim: "SSID name: \(network.SSIDName ?? "Not connected to Wi-Fi")")
                Button("Test", action: {
                    
                    let networkData = self.performNetworkQualityTest()
                    
                    let networkQualityTest = NetworkQualityTest(context: managedObjectContext)
                    
                    switch network.connectionStatus {
                    case .satisfied:
                        networkQualityTest.connectionStatus = "Connected"
                    case .unsatisfied:
                        networkQualityTest.connectionStatus = "Not connected"
                    default:
                        networkQualityTest.connectionStatus = "Unknown"
                    }
                    
                    switch network.connectionType {
                    case .wifi:
                        networkQualityTest.interfaceType = "Wi-Fi"
                    case .wiredEthernet:
                        networkQualityTest.interfaceType = "Wired"
                    case .cellular:
                        networkQualityTest.interfaceType = "Cellular"
                    default:
                        networkQualityTest.interfaceType = "Unknown"
                    }
                    
                    networkQualityTest.id = UUID()
                    networkQualityTest.isExpensive = network.isExpensive
                    networkQualityTest.isConstrained = network.isConstrained
                    networkQualityTest.ssidName = network.SSIDName
                    networkQualityTest.startDate = networkData.startDate
                    networkQualityTest.endDate = networkData.endDate
                    networkQualityTest.downlinkSpeed = Int32(networkData.dlThroughput)
                    networkQualityTest.uplinkSpeed = Int32(networkData.ulThroughput)
                    networkQualityTest.responsiveness = Int32(networkData.responsiveness)
                    networkQualityTest.latency = networkData.baseRtt
                    
                    try? managedObjectContext.save()
                })
            }
            List {
                ForEach(networkQualityTests) { networkQualityTest in
                    HStack {
                        Text(networkQualityTest.id?.description ?? "Unknown ID")
                        Text(networkQualityTest.connectionStatus ?? "Unknown status")
                        Text(networkQualityTest.interfaceType ?? "Unknown interface")
                        Text(networkQualityTest.latency.description)
                        Text(networkQualityTest.responsiveness.description)
                        Text(networkQualityTest.startDate!.description)
                        Text(networkQualityTest.endDate!.description)
                        Text(networkQualityTest.downlinkSpeed.description)
                        Text(networkQualityTest.uplinkSpeed.description)
                    }
                }
            }
        }.padding()
        
    }
    
    func performNetworkQualityTest() -> NetworkData {

        let shellUtility = ShellUtility()
        let rawData = shellUtility.executeCommand("networkQuality -c")
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
        //dateFormatter.locale = Locale(identifier: "en_US")
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let networkData: NetworkData = try! decoder.decode(NetworkData.self, from: rawData)
        
        return networkData
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
