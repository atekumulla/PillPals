//
//  MedInfoView.swift
//  PillPals
//
//  Created by anush on 1/17/24.
//

import SwiftUI

struct MedInfoView: View {
    var medication: Medication

    var body: some View {
        VStack(alignment: .leading) {
            Text(medication.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()

            VStack(alignment: .leading, spacing: 16) {
                Text("Type: \(medication.type.rawValue)")
                Text("Dosage: \(medication.dosage.amount) \(medication.dosage.unit.rawValue)")
                Text("Start Date: \(formattedDate(medication.startDate))")
                Text("End Date: \(formattedDate(medication.endDate))")
                Text("Priority: \(medication.priority.rawValue)")
                Text("Active: \(medication.active ? "Yes" : "No")")
                Text("Period: ")
                Image(systemName: medication.period.rawValue)
                    .font(.system(size: 30))
                Text("Image:")
                Image(systemName: medication.imageName) // Assuming imageName is the SF Symbol name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40) // Adjust the size as needed
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding()

            Spacer()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    MedInfoView(medication: dummyMedications[0])
}
