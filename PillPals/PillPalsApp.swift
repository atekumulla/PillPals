//
//  PillPalsApp.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/19/23.
//
import SwiftUI

@main
struct PillPalsApp: App {
    // @StateObject private var store = MedStore() // Ensure MedStore has the necessary properties
    @StateObject private var dataController = DataController()
    //@StateObject private var notificationManager = NotificationManager.shared
    /*init() {
        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }*/
    init() {
           // Initialize and request notification permissions using NotificationManager
           NotificationManager.shared.requestAuthorization()
    }
    var body: some Scene {
        WindowGroup {
            TabView {
                // Assuming HomeView expects a Binding<[Medication]>
                HomeView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                PillPalsView(emergencyContacts: dummyEmergencyContacts)
                                .tabItem {
                                    Image(systemName: "person")
                                    Text("PillPals")
                                }

                UserProfileForm() // Assuming UserProfileForm doesn't need data from store
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    //.environmentObject(store) // Injecting store into the environment
                    .tabItem {
                        Label("Profile", systemImage: "gear")
                    }
            }
        }
    }
}
