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
let dummyTimeToTake1 = Calendar.current.date(from: DateComponents(hour: 9, minute: 41))!
let dummyTimeToTake2 = Calendar.current.date(from: DateComponents(hour: 13, minute: 21))!


let datesList = [startDate, endDate]


let dummyMedications: [Medication] = [
    Medication(
        name: "Aspirin",
        type: .tablet,
        dosage: Dosage(amount: 5, unit: .milligrams),
        datesToTake: createDummyMedicationDates(startDate: startDate, endDate: endDate, daysOfWeek: dummyDaysOfWeek),

        daysOfWeekToTake: dummyDaysOfWeek,
        startDate: startDate,
        endDate: endDate,
        timeToTake: dummyTimeToTake1,
        color: .red,
        priority: .normal,
        imageName: "pills", 
        period: MedicationPeriod.morning
    ),
    Medication(
        name: "Ibuprofen",
        type: .capsule,
        dosage: Dosage(amount: 1, unit: .milligrams),
        datesToTake: createDummyMedicationDates(startDate: startDate, endDate: endDate, daysOfWeek: dummyDaysOfWeek),
        daysOfWeekToTake: dummyDaysOfWeek,
        startDate: startDate,
        endDate: endDate,
        timeToTake: dummyTimeToTake2,
        color: .blue,
        priority: .high,
        imageName: "pills",
        period: MedicationPeriod.night
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


func createDummyMedicationDates(startDate: Date, endDate: Date, daysOfWeek: [DayOfWeek]) -> [MedicationDateStatus] {
    var dates = [MedicationDateStatus]()
    var currentDate = startDate

    let calendar = Calendar.current
    while currentDate <= endDate {
        let weekDay = calendar.component(.weekday, from: currentDate)

        if daysOfWeek.contains(where: { $0.calendarValue == weekDay }) {
            let dateStatus = MedicationDateStatus(date: currentDate, taken: false)
            dates.append(dateStatus)
        }

        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
        currentDate = nextDay
    }

    return dates
}
