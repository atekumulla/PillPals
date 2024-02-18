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
    @State var medication: Medication
    @State private var isDatesListExpanded: Bool = false // To control the expandable list
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DisplayMedicationView(medication: dummyMed)
                
                Divider()
                
                Group {
                    LabelledValue(label: "Priority") {
                        Text(medication.priority.rawValue.capitalized)
                            .foregroundColor(medication.priority == .high ? .red : .primary)
                    }
                    
                    LabelledValue(label: "Time Period") {
                        Image(systemName: medication.period.rawValue)
                            .foregroundColor(.primary)
                    }
                    
                    LabelledValue(label: "Time to Take") {
                        Text(medication.timeToTake, style: .time)
                    }
                    
                    LabelledValue(label: "Start Date") {
                        Text(formatDate(medication.startDate))
                    }
                    
                    LabelledValue(label: "End Date") {
                        Text(formatDate(medication.endDate))
                    }
                    
                }
                .padding(.vertical, 1)
                
                CalendarView(medication: medication)
                    .padding()
                
                DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(medication.datesToTake, id: \.date) { dateStatus in
                            HStack {
                                Text(formatDate(dateStatus.date))
                                Spacer()
                                Image(systemName: "checkmark.circle.fill" )
                                    .foregroundColor( .green)
                                /*Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(dateStatus.taken ? .green : .secondary)*/
                            }
                        }
                    }
                    .padding()
                }
                .accentColor(.primary)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct LabelledValue<ValueView: View>: View {
    let label: String
    let valueView: ValueView
    
    init(label: String, @ViewBuilder valueView: () -> ValueView) {
        self.label = label
        self.valueView = valueView()
    }
    
    var body: some View {
        HStack {
            Text("\(label):")
                .bold()
            valueView
        }
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
