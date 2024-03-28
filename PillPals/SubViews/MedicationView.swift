//
//  MedicationView.swift
//  PillAppTestTesting
//
//  Created by Aadi Shiv Malhotra on 11/12/23.
//

import Foundation
import SwiftUI


struct MedicationDetailView: View {
    var medication: Medication
    @State private var isDatesListExpanded: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Displaying the medication details that were previously in HeaderView
                Text(medication.name ?? "Medication Name")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack {
                    Image(systemName: "pills")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Time To Take \(medication.timeToTake?.formatted(date: .omitted, time: .shortened) ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Start Date \(formatDate(medication.startDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("End Date \(formatDate(medication.endDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom, 20)
                
                // Dosage and other medication details
                MedicationDetailsView(medication: medication)
                
                Divider()
                
                DatesToTakeCalendarView(medication: medication)
                    .padding()
                
                DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                    DosingScheduleView(medication: medication)
                }
                .accentColor(.primary)
            }
            .padding()
        }
    }
    
    
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// Define your MedicationDetailsView, DosingScheduleView, and any other components as before.


// Rest of your views...


// PreferenceKey to read the scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



struct HeaderView: View {
    var medication: Medication
    var backgroundColor = sampleColor
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(medication.name ?? "Medication Name")
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "pills")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Time To Take \(medication.timeToTake?.formatted(date: .omitted, time: .shortened) ?? "")")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("Start Date \(formatDate(medication.startDate))")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("End Date \(formatDate(medication.endDate))")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.all)) // Apply the background here
        
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

/*struct HeaderView: View {
 var medication: Medication
 var backgroundColor = sampleColor
 
 var body: some View {
 ZStack {
 backgroundColor.edgesIgnoringSafeArea(.all)
 
 VStack(alignment: .leading, spacing: 8) {
 HStack {
 Image(systemName: "pills")
 .foregroundColor(.white)
 .font(.title2)
 Text(medication.name ?? "Medication Name")
 .font(.title3)
 .fontWeight(.semibold)
 .foregroundColor(.white)
 }
 
 Text("Time To Take \(medication.timeToTake?.formatted(date: .omitted, time: .shortened) ?? "")")
 .font(.subheadline)
 .foregroundColor(.white)
 
 Text("Start Date \(formatDate(medication.startDate))")
 .font(.subheadline)
 .foregroundColor(.white)
 
 Text("End Date \(formatDate(medication.endDate))")
 .font(.subheadline)
 .foregroundColor(.white)
 }
 .padding()
 }
 .background(sampleColor)
 }
 
 private func formatDate(_ date: Date?) -> String {
 guard let date = date else { return "N/A" }
 let formatter = DateFormatter()
 formatter.dateStyle = .medium
 formatter.timeStyle = .none
 return formatter.string(from: date)
 }
 }*/

struct MedicationDetailsView: View {
    var medication: Medication
    
    var body: some View {
        HStack {
            Text("Dosage")
                .bold()
            Spacer()
            Text("\(medication.dosage?.amount ?? 0, specifier: "%.1f") \(medication.dosage?.unit ?? "Unit")")
        }
    }
}

struct DosingScheduleView: View {
    var medication: Medication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ForEach(medication.dateStatusArray, id: \.date) { dateStatus in
                HStack {
                    Text(formatDate(dateStatus.date))
                    Spacer()
                    Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(dateStatus.taken ? .green : .gray)
                }
            }
        }
        .padding()
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.headline)
                Text("Back")
            }
        }
    }
}
