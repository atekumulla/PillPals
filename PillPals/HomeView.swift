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
                VStack(alignment: .leading) {
                    // Greeting to the user
                    Text("Due Next:")
                        .font(.title)
                        .padding()

                    ScrollView{
                        MedicationView(medications: MedicationData.medications)
                    }
                
                    Spacer()

                }
                .navigationBarTitle("Hello, John!", displayMode: .large)
                .navigationBarItems(
                    trailing:
                        NavigationLink(destination: PillPalsView()) {
                            Image(systemName: "person.fill")
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
            .navigationBarTitle("PillPals", displayMode: .inline)
        
//        VStack{
//            BottomTabView()
//        }
    }
}

#Preview {
    HomeView()
}
