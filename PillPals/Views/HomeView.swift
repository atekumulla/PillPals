//
//  HomeView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/21/23.
//

import Foundation
import SwiftUI

/*struct Medication: Identifiable {
    var id = UUID()
    var color: Color
    var name: String
    var dosage: String
    var time: String
    var period: MedicationPeriod
}*/

let demoUser = User(name: "John", age: 55)

func timeString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a" // This format sets the time in the 12-hour format with AM/PM
    return formatter.string(from: date)
}

struct HomeView: View {
    // Example medications
    @State private var medications: [Medication] = dummyMedications
    @State private var showingAddMedicationView = false

    @State private var homeViewDemoUser: User = demoUser
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(medications) { medication in
                        NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                MedicationView(medication: medication)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Hello " + homeViewDemoUser.name + "!")
            .toolbar {
                Button(action: {
                    showingAddMedicationView = true
                }) {
                    Image(systemName: "plus")
                }
                
            }
        }
        .sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView(medications: $medications)
        }
    }
}

struct MedicationView: View {
    var medication: Medication
    
    var body: some View {
        VStack(alignment: .leading) {
            

            Text(timeString(from: medication.timeToTake))
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: medication.period.rawValue)
                    .foregroundColor(medication.color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(medication.name)
                        .font(.largeTitle
                        )
                        .foregroundColor(.primary)
                    Text("\(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "hand.tap.fill")
                    //.foregroundStyle(.secondary)
                    .foregroundColor(.primary)
                    
                
            }
            .padding()
            .background(medication.color.opacity(0.3))
            .cornerRadius(12)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


