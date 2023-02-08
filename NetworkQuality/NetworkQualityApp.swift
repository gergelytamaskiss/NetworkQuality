//
//  NetworkQualityApp.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 01. 30..
//

import SwiftUI

@main
struct NetworkQualityApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var monitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext).environmentObject(monitor)
        }
    }
}
