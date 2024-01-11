//
//  MedExpand.swift
//  PillPals
//
//  Created by Ramses  Mendoza on 1/10/24.
//
// MedicationDetailView.swift
import SwiftUI
import Foundation

struct MedicationDetailView: View {
    var medication: Medication

    var body: some View {
        VStack {
            Text("Medication Details")
                .font(.title)
                .padding()

            // Display Medication details
            Text("Brand Name: \(medication.Brand_name)")
            Text("Status Color: \(medication.Status_color.description)")
            Text("Priority Color: \(medication.priority_color.description)")
            Text("Dosage: \(medication.dosage)")
            Text("Active: \(medication.Active ? "Yes" : "No")")

            Spacer()
        }
        .navigationTitle(medication.Brand_name)
    }
}
