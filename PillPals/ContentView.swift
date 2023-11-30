//
//  ContentView.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//
import SwiftUI
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // Greeting to the user
                Text("Due Next:")
                    .font(.title)
                    .padding()

                MedicationView(medications: MedicationData.medications)

                Spacer()

                // Bottom tab navigation
                BottomTabView()
            }
            .navigationBarTitle("Hello, John!", displayMode: .large)
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: PillPalsView()) {
                        Image(systemName: "list.bullet")
                            .imageScale(.large)
                            .padding()
                    }
            )
        }
    }
}


struct PillPalsView: View {
    var body: some View {
        // Customize the PillPals view with emergency contacts
        Text("PillPals Page - Emergency Contacts")
            .navigationBarTitle("PillPals", displayMode: .inline)
    }
}

struct CaregiverView: View {
    var body: some View {
        Text("Caregiver Page")
            .navigationBarTitle("Caregiver", displayMode: .inline)
    }
}

#Preview {
    ContentView()
}
