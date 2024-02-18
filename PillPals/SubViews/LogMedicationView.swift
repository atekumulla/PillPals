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
    @EnvironmentObject var medStore: MedStore
    @Binding var isPresented: Bool
    @State private var showReminderOptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Medication")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(medication.name)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding()

                Divider()

                VStack(alignment: .leading) {
                    Text("Dosage")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("\(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()

                Text("Today's Date: \(Date(), formatter: LogMedicationSheet.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()

                Spacer()

                Button(action: {
                    markMedicationAsTaken()
                    isPresented = false
                }) {
                    Text("Mark as Taken")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(22)
                }
                .padding(.horizontal)

                Button(action: {
                    // Handle not taken action
                    isPresented = false
                }) {
                    Text("Mark as Not Taken")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(22)
                }
                .padding([.horizontal])

                Button(action: {
                    showReminderOptions = true
                }) {
                    HStack {
                        Image(systemName: "bell")
                        Text("Remind Me")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(22)
                }
                .padding(.horizontal)
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

    /**
     private func markMedicationAsTaken() {
             Task {
                 await medStore.markMedicationAsTaken(medicationId: medication.id, on: Date(), forDoseIndex: 0)
                 // Perform any other UI updates here if necessary
             }
         }
     */
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

///
/*
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

*/
