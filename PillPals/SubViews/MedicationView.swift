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

/// Shows the details of the Medication as a view
struct MedicationDetailView: View {
    @State var medication: Medication
    @State private var isDatesListExpanded: Bool = false // To control the expandable list
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            /// Displays a colorful rectangle with info abt medication - basic version of MedView on home pg
            DisplayMedicationView(medication: medication)
            Divider()
            ScrollView {
                
                VStack(alignment: .leading, spacing: 10) { // Leading alignment and spacing between elements
                    HStack {
                        Text("Type:")
                            .bold()
                        Text(medication.type.rawValue.capitalized)
                    }
                    
                    
                    HStack {
                        Text("Priority:")
                            .bold()
                        Text(medication.priority.rawValue.capitalized)
                            .foregroundColor(medication.priority == .high ? .red : .primary)
                    }
                    
                    HStack {
                        Text("Time Period:")
                            .bold()
                        Image(systemName: medication.period.rawValue)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time to take:")
                            .bold()
                        Text(medication.timeToTake, style: .time)
                    }
                    
                    HStack {
                        Text("Start Date:")
                            .fontWeight(.semibold)
                        Text(formatDate(medication.startDate))
                    }
                    
                    HStack {
                        Text("End Date:")
                            .fontWeight(.semibold)
                        Text(formatDate(medication.endDate))
                    }
                    
                    
                    CalendarView(medication: medication)
                        .padding()
                    
                    DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                        VStack(alignment: .leading) {
                            ForEach(medication.datesToTake, id: \.date) { dateStatus in
                                HStack {
                                    Text(formatDate(dateStatus.date))
                                    Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        .padding()
                    }
                    .accentColor(.primary)
                }
                .padding() // Padding for the VStack
            }
            
            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView(medication: dummyMedications[1])
    }
}

struct DisplayMedicationView: View {
    var medication: Medication
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            HStack {
                Image(systemName: medication.period.rawValue)
                //.resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(medication.color.color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(medication.name)
                        .font(.largeTitle
                        )
                        .foregroundColor(.primary)
                    Text("\(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "hand.tap.fill")
                //.foregroundStyle(.secondary)
                    .foregroundColor(.primary)
                
                
                
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(medication.uiColor.opacity(0.5)))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(medication.uiColor, lineWidth: 2)
            )
        }
        //.padding(.vertical, 4)
        
    }
}
