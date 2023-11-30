//
//  PillPalsApp.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//
import SwiftUI

@main
struct PillPalsApp: App {
    @StateObject private var store = MedStore() // Ensure MedStore has the necessary properties

    var body: some Scene {
        WindowGroup {
            TabView {
                // Assuming HomeView expects a Binding<[Medication]>
                HomeView(meds: $store.meds) {
                    Task {
                            do {
                                try await store.save(medications: store.meds)
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                        }
                } // Ensure 'meds' is a property in MedStore
                    .task {
                        do {
                                try await store.load()
                            } catch {
                                fatalError(error.localizedDescription)
                            }
                    }
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                

                UserProfileForm() // Assuming UserProfileForm doesn't need data from store
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
        }
    }
}

