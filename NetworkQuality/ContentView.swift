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
    
    @State private var testInProgress = ""
    
    private var connectionStatus: String {
        switch network.connectionStatus {
        case .satisfied:
            return "Connected"
        case .unsatisfied:
            return "Not connected"
        default:
            return "Unknown"
        }
    }
    
    private var interfaceType: String {
        switch network.connectionType {
        case .wifi:
            return "Wi-Fi"
        case .wiredEthernet:
            return "Ethernet"
        case .cellular:
            return "Cellular"
        default:
            return "Unknown"
        }
    }
    
    var body: some View {
        VStack {
            Table(of: NetworkQualityTest.self) {
                TableColumn("Type") { networkQualityTests in
                    Image(systemName: networkQualityTests.wrappedInterfaceType)
                }.width(20)
                TableColumn("Date", value: \.wrappedStartDate.description)
                    .width(145)
                TableColumn("Duration", value: \.duration)
                TableColumn("Sequential") { networkQualityTests in
                    if !networkQualityTests.wrappedSequential.isEmpty {
                        Image(systemName: networkQualityTests.wrappedSequential)
                    }
                }.width(20)
                TableColumn("Download (Mbps)", value: \.wrappedDownloadSpeed)
                    .width(100)
                TableColumn("Upload (Mbps)", value: \.wrappedUploadSpeed)
                    .width(100)
                TableColumn("Latency", value: \.wrappedLatency)
                TableColumn("Responsiveness (RPM)", value: \.responsiveness.description)
                TableColumn("Wi-Fi Name", value: \.wrappedSSIDName)
            } rows: {
                ForEach(networkQualityTests) { networkQualityTest in
                    TableRow(networkQualityTest)
                        .contextMenu {
                            Button("Delete") {
                                managedObjectContext.delete(networkQualityTest)
                                try? managedObjectContext.save()
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    Button(action: {
                        performNetworkQualityTest()
                    }, label: {
                        Image(systemName: "play.fill")
                    })
                    Button(action: { }, label: {
                        Image(systemName: "gearshape.fill")
                    })
                }
            }
            
            HStack() {
                Text(connectionStatus)
                Text("|")
                Text(interfaceType)
                Text(testInProgress)
                Spacer()
            }
            .padding(5)
        }
    }
    
    func performNetworkQualityTest() {
        
        let shellUtility = ShellUtility()
        let runSequentially = UserDefaults.standard.bool(forKey: "runSequentially") ? " -s" : ""
        
        DispatchQueue.global(qos: .background).async {
            let rawData = shellUtility.executeCommand("networkQuality -c" + runSequentially)
            DispatchQueue.main.async {
                
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let networkData = try! decoder.decode(NetworkData.self, from: rawData)
                
                let networkQualityTest = NetworkQualityTest(context: managedObjectContext)
                networkQualityTest.id = UUID()
                networkQualityTest.downlinkSpeed = networkData.dlThroughput
                networkQualityTest.startDate = networkData.startDate
                networkQualityTest.latency = networkData.baseRtt
                networkQualityTest.endDate = networkData.endDate
                networkQualityTest.uplinkSpeed = networkData.ulThroughput
                networkQualityTest.connectionStatus = connectionStatus
                networkQualityTest.interfaceType = interfaceType
                networkQualityTest.runSequentially = UserDefaults.standard.bool(forKey: "runSequentially")
                networkQualityTest.ssidName = network.SSIDName
                networkQualityTest.isExpensive = network.isExpensive
                networkQualityTest.isConstrained = network.isConstrained
                
                try? managedObjectContext.save()
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
