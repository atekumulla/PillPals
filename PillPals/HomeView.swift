//
//  HomeView.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//
import SwiftUI
struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Greeting to the user
                Text("Hello, User!")
                    .font(.title)
                    .padding()

                // Additional medications under "Due Now" and "Due Next"
                MedicationView(
                    medications: [
                        Medication(name: "Adderal", dosage: "15 mg", instructions: "Take with water", dueStatus: "Due Now"),
                        Medication(name: "Cocaine", dosage: "25 mg", instructions: "Take after meals", dueStatus: "Due Next")
                        // Add more medications as needed
                    ]
                )

                Spacer()

                // Bottom tab navigation
                TabView {
                    NavigationLink(destination: CaregiverView()) {
                        Image(systemName: "person")
                        Text("Caregiver")
                    }
                    .tabItem {
                        Image(systemName: "person")
                        Text("Caregiver")
                    }

                    NavigationLink(destination: HomeView()) {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }

//                    NavigationLink(destination: MedicationView()) {
//                        Image(systemName: "pills")
//                        Text("Medications")
//                    }
//                    .tabItem {
//                        Image(systemName: "pills")
//                        Text("Medications")
//                    }
                }
                .padding()
            }
            .navigationBarTitle("Home", displayMode: .large)
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: PillPalsView()) {
                        Image(systemName: "star")
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
