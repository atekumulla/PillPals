//
//  DataController.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/29/23.
//

import Foundation
import SwiftUI
import CoreData


// can use @stateobj so can stay alive for app lifetime
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PillPalsData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
}
