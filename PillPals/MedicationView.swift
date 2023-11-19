//
//  MedicationView.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//
import SwiftUI

struct MedicationView: View {
    var medications: [Medication]

    var body: some View {
        VStack {
            ForEach(medications) { medication in
                MedicationBoxView(
                    medicationName: medication.name,
                    dosage: medication.dosage,
                    instructions: medication.instructions,
                    nextDue: medication.dueStatus
                )
            }
        }
        .padding()
    }
}


struct MedicationBoxView: View {
    var medicationName: String
    var dosage: String
    var instructions: String
    var nextDue: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(medicationName)
                .font(.title)
                .foregroundColor(.blue)

            Divider()

            HStack {
                Text("Dosage:")
                Spacer()
                Text(dosage)
            }

            HStack {
                Text("Instructions:")
                Spacer()
                Text(instructions)
            }

            HStack {
                Text("Next Due:")
                Spacer()
                Text(nextDue)
                    .foregroundColor(nextDue == "Due Now" ? .red : .green)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
