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
                        MedicationView(medications: dummyMedications)
                    }
                    .padding(.bottom)
                }
                .navigationBarTitle("Hello, John!", displayMode: .large)
                .navigationBarItems(
                    trailing:
                        NavigationLink(destination: CaregiverView()) {
                            Image(systemName: "person.fill")
                                .imageScale(.large)
                                .padding()
                        }
                )
            
        }
        
    }
}

#Preview {
    HomeView()
}
