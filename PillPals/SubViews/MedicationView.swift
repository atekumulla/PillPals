//
//  MedicationView.swift
//  PillAppTestTesting
//
//  Created by Aadi Shiv Malhotra on 11/12/23.
//

import Foundation

import SwiftUI


struct CornerRadiusShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MedicationDetailView: View {
    @State private var color: Color = Color(red: 180.0/255.0, green: 200.0/255.0, blue: 220.0/255.0)
    var medication: Medication
    @State private var isDatesListExpanded: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DisplayMedicationView(medication: medication, color: color)
                
                Divider()
                
                    /*Group {
                    HStack {
                        Text("Time Period:")
                            .bold()
                        Image(systemName: medication.period ?? "clock.arrow.circlepath")
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time to Take:")
                            .bold()
                        Text(medication.timeToTake, style: .time)
                    }
                    
                    HStack {
                        Text("Start Date:")
                            .bold()
                        Text(formatDate(medication.startDate))
                    }
                    
                    HStack {
                        Text("End Date:")
                            .bold()
                        Text(formatDate(medication.endDate))
                    }
                }
                .padding(.vertical, 1)*/
                
                CalendarView(medication: medication)
                    .padding()
                
                DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                    VStack(alignment: .leading, spacing: 5) {
                        // Assuming datesToTake properly initialized and iterable
                        ForEach(medication.dateStatusArray, id: \.date) { dateStatus in
                            HStack {
                                Text(formatDate(dateStatus.date))
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                }
                .accentColor(.primary)
            }
            .padding()
        }
        .navigationTitle("\(medication.name ?? "Medication")")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct DisplayMedicationView: View {
    var medication: Medication
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "pills")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(medication.name ?? "Unknown")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Text("\(medication.dosage?.amount ?? 0, specifier: "%.1f") \(medication.dosage?.unit ?? "mg")")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "hand.tap.fill")
                    .foregroundColor(.primary)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.5)))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
}
