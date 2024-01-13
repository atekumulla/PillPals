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
            CaregiverView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Caregiver")
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
