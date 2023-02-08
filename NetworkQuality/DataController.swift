//
//  DataController.swift
//  NetworkQuality
//
//  Created by Gergely Kiss on 2023. 02. 08..
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "NetworkQuality")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
            
        }
    }
}
