//
//  ProfileView.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/10/23.
//

import Foundation
import SwiftUI

let startDate = DateComponents(calendar: .current, year: 2023, month: 11, day: 9).date!
let endDate = DateComponents(calendar: .current, year: 2023, month: 12, day: 23).date!
let dummyDaysOfWeek: [DayOfWeek] = [.monday, .wednesday, .friday] // Example dummy data
let dummyTimeToTake = Calendar.current.date(from: DateComponents(hour: 8, minute: 0))!


let datesList = [startDate, endDate]


let dummyMedications: [Medication] = [
    Medication(
        name: "Aspirin",
        type: .tablet,
        datesToTake: datesList,
        daysOfWeekToTake: dummyDaysOfWeek,
        startDate: startDate,
        endDate: endDate,
        timeToTake: dummyTimeToTake,
        color: .red,
        priority: .normal,
        imageName: "pills"
    ),
    Medication(
        name: "Ibuprofen",
        type: .capsule,
        datesToTake: datesList,
        daysOfWeekToTake: dummyDaysOfWeek,
        startDate: startDate,
        endDate: endDate,
        timeToTake: dummyTimeToTake,
        color: .red,
        priority: .high,
        imageName: "pills"
    ),
    // ... more dummy medications
]


struct UserProfileForm: View {
    // ... existing properties
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var medications: [Medication] = dummyMedications // Array to hold medications
    @State private var showingDeleteAlert = false
    @State private var medicationToDelete: Medication?
    @State private var showingAddMedication = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Age", text: $age)
                    // Include other personal fields as necessary
                }

                Section(header: Text("Medications")) {
                    ForEach(medications) { medication in
                        NavigationLink(destination: MedicationDetailView(medication: medication)) {
                            HStack {
                                Image(systemName: medication.imageName)
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(medication.name).font(.headline)
                                    Text(medication.type.rawValue.capitalized)
                                }
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else { return }
                        medicationToDelete = medications[index]
                        showingDeleteAlert = true
                    })
                    Button("Add Medication") {
                        showingAddMedication = true
                    }
                }
            }
            .navigationBarTitle("User Profile")
            .navigationBarItems(trailing: EditButton())
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Medication"),
                    message: Text("Are you sure you wish to delete medication: \(medicationToDelete?.name ?? "")?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let medication = medicationToDelete, let index = medications.firstIndex(where: { $0.id == medication.id }) {
                            medications.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        } // End of NavigationView
        .sheet(isPresented: $showingAddMedication) {
            //AddMedicationView(medications: $medications)
            AddMedicationView(medications: $medications)
        }
    }

    // ... existing methods
    private func deleteMedication(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
    }

    private func addMedication() {
        // Implement this function to add a new medication
        // For example, you could present a modal form to input medication details
    }
}



struct UserProfileForm_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileForm()
    }
}
