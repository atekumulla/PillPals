//
//  MedicationView.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//
import SwiftUI

struct MedicationView: View {
    var medications: [Medication]

    private var medicationsByPeriod: [MedicationPeriod: [Medication]] {
        let today = Calendar.current.component(.weekday, from: Date())
        
        let medicationsForToday = medications.filter { medication in
            medication.daysOfWeekToTake.contains(where: { $0.calendarValue == today })
        }

        var result: [MedicationPeriod: [Medication]] = [:]

        for medication in medicationsForToday {
            if let periodList = result[medication.period] {
                result[medication.period] = periodList + [medication]
            } else {
                result[medication.period] = [medication]
            }
        }

        return result
    }

    var body: some View {
        VStack {
            // Display medications for each period
            ForEach(MedicationPeriod.allCases, id: \.self) { period in
                if let periodMedications = medicationsByPeriod[period] {
                    Section(header: HStack {
                        Image(systemName: period.rawValue)
                            .font(.system(size: 30)) // Adjust the font size as needed
                        Spacer() // Add Spacer to push the image to the left
                    }) {
                        ForEach(periodMedications) { medication in
                            MedicationBoxView(
                                medication: medication
                            )
                        }
                    }
                }
            }
        }
        .padding()
    }
}




struct MedicationBoxView: View {
    var medication: Medication

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(medication.name)
                    .font(.title)
                    .foregroundColor(.blue)
                
                Spacer()
                
                // Display the image of the medication
                Image(systemName: medication.imageName) // Assuming imageName is the SF Symbol name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40) // Adjust the size as needed
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }

            Divider()

            HStack {
                Text("Dosage:")
                Spacer()
                Text("\(medication.dosage.amount) \(medication.dosage.unit.rawValue)")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    MedicationView(medications: dummyMedications)
}


