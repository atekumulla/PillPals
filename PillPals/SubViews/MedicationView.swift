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
                /*HStack {
                 Image(systemName: "pills")
                 .foregroundColor(.secondary)
                 .font(.largeTitle)
                 
                 Text(medication.name ?? "Medication Name")
                 .font(.largeTitle)
                 .foregroundColor(.primary)
                 .bold()
                 }*/
                
                
                
                // Dosage and other medication details
                MedicationDetailsView(medication: medication)
                
                Divider()
                
                DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                    DosingScheduleView(medication: medication)
                }
                
                Divider()
                
                DatesToTakeCalendarView(medication: medication)
                    .padding()
                
                
                //.accentColor(.primary)
            }
            .padding()
        }
        .navigationTitle(medication.name!)
        .navigationBarTitleDisplayMode(.large)
        
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
        VStack(spacing: 15) { // Increased spacing between elements
            /*Text(medication.name!)
                .bold()
                .foregroundColor(.primary)
                .padding(.bottom, 5) // Add padding below the name for more separation*/
            
            //Divider()
            
            detailRow(title: "Time to Take:", value: medication.timeToTake?.formatted(date: .omitted, time: .shortened) ?? "N/A")
            
            Divider()
            
            detailRow(title: "Dosage:", value: "\(medication.dosage?.amount ?? 0) \(medication.dosage?.unit ?? "Unit")")
            
            Divider()
            
            detailRow(title: "Start Date:", value: formatDate(medication.startDate))
            
            Divider()
            
            detailRow(title: "End Date:", value: formatDate(medication.endDate))
        }
        .padding() // Adjust overall padding as needed
        .background(Color.blue.opacity(0.4))
        .cornerRadius(10)
        .padding(.horizontal, 5) // Optionally add some horizontal padding to the entire card
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .bold()
                .foregroundColor(.primary)
            Spacer()
            Text(value)
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


struct DosingScheduleView: View {
    var medication: Medication
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let sortedDateStatusArray = medication.dateStatusArray.sorted {
            $0.date! < $1.date!
        }
        
        return VStack(alignment: .leading, spacing: 8) {
            ForEach(sortedDateStatusArray, id: \.date) { dateStatus in
                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(dateStatus.taken ? .green : .red)
                    Text(formatDate(dateStatus.date!))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Spacer()
                    Text(dateStatus.taken ? "Taken" : "Missed")
                        .foregroundColor(dateStatus.taken ? .green : .red)
                        .bold()
                    Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(dateStatus.taken ? .green : .red)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.40))
        .cornerRadius(10)
        .padding(.horizontal, 5)
    }
    
    private func formatDate(_ date: Date) -> String {
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
/*
 struct EnhancedDosingScheduleView: View {
 var medication: Medication
 @State private var isExpanded = false
 
 var body: some View {
 DisclosureGroup(
 isExpanded: $isExpanded,
 content: {
 DosingScheduleView(medication: medication)
 },
 label: {
 HStack {
 Text("Dosing Schedule")
 .font(.headline)
 .foregroundColor(.white)
 Spacer()
 Image(systemName: "chevron.right.circle")
 .imageScale(.large)
 .rotationEffect(.degrees(isExpanded ? 90 : 0))
 .foregroundColor(.white)
 }
 .padding()
 .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .leading, endPoint: .trailing))
 .cornerRadius(10)
 .shadow(radius: 3)
 })
 .accentColor(.white)
 .padding([.horizontal, .top])
 }
 }
 */
