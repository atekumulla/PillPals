//
//  LogMedicationView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/30/23.
//

import Foundation
import SwiftUI

// MARK: - LogMedicationSheet

/// A sheet view for logging medication intake.
struct LogMedicationSheet: View {
    var medication: Medication
    @Binding var isPresented: Bool
    @State private var showReminderOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Medication: \(medication.name)")
                Text("Dosage: \(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                Text("Today's Date: \(Date(), formatter: LogMedicationSheet.dateFormatter)")
                
                Button("Mark as Taken") {
                    markMedicationAsTaken()
                    isPresented = false
                }
                
                Button("Mark as Not Taken") {
                    // Handle not taken action
                    isPresented = false
                }
                
                Button("Remind Me") {
                    showReminderOptions = true
                }
                
                Spacer()
            }
            .navigationTitle("Medication Details")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
        .sheet(isPresented: $showReminderOptions) {
            ReminderOptionsView(medication: medication, isPresented: $showReminderOptions)
        }
    }
    
    private func markMedicationAsTaken() {
        // Logic to mark medication as taken
    }
    /// DateFormatter for displaying the date in the sheet.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

