//
//  ContentView.swift
//  PillPals
//
//  Created by anush on 1/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PillPalsView(emergencyContacts: dummyEmergencyContacts)
                .tabItem {
                    Image(systemName: "person")
                    Text("PillPals")
                }
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            MedPageView(medications: dummyMedications)
                .tabItem {
                    Image(systemName: "pills")
                    Text("Medications")
                }
        }
    }
}

#Preview {
    ContentView()
}
