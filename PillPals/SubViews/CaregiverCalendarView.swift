//
//  CaregiverCalendarView.swift
//  PillPals
//
//  Created by Tania Sapre on 3/13/24.
//

import SwiftUI

struct CaregiverCalendarView: View {
    var medication: Medication
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil // Initialize with the current date
    @State private var buttonPressed: Bool = false
    @State private var medicationHistory: [String: [MedicationEntry]] = [:] // Medication history for each day
    let formatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter
       }()
    let formatterDouble: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyyMMdd"
           return formatter
       }()
    var body: some View {
        VStack {
            // Calendar header
            Text("Calendar")
                .font(.title)
                .padding(.top, 20)
            
            // Calendar view
            LazyVGrid(columns: columns) {
                ForEach(0..<7) { index in
                    let date = dateForDay(index: index)
                    let dayWeek: String = dayOfWeek(for: date)
                    let currentDate_week: String = dayOfWeek(for: currentDate)
                    
                    VStack { // Use VStack to stack day of week and day of month vertically
                        Text("\(dayOfWeek(for: date))") // Display day of the week horizontally
                            .font(.callout)
                        Button(action: {
                            selectedDate = date // Set the selected date when clicked
                            buttonPressed = true
                            let selected_date_double: Double = DoubleDateFormatted()
                            print(selected_date_double)
                        }) {
                            Text("\(dayOfMonth(for: date))")
                                .frame(width: 30, height: 30)
                                .background(
                                    // Highlight light blue if the date is selected
                                    (selectedDate == date && buttonPressed) || (!buttonPressed && dayWeek == currentDate_week) ? Color.blue.opacity(0.3) : Color.clear
                                )
                                .cornerRadius(15)
                        }
                    }
                }
            }
            // Medication Info section
            
            let currentDate_double: Double =  Double(formatterDouble.string(from: currentDate)) ?? 0 // Move this line here
            let currentDate_week: String = formatter.string(from: currentDate)
            VStack(alignment: .leading) {
                Text("Medication Info: ")
                    .font(.headline)
                    .padding(.top, 20)
                if(!buttonPressed && selectedDate == nil){
                    //display info about the current date
                    if let medications = medicationHistory[currentDate_week] {
                        ForEach(medications, id: \.self) { medicationEntry in
                            Text("\(medicationEntry.medication.name) - \(medicationEntry.medication.time)")
                                .font(.subheadline)
                        }
                    }
                } else if(DoubleDateFormatted() < currentDate_double){
                    if let medications = medicationHistory[currentDate_week] {
                        ForEach(medications, id: \.self) { medicationEntry in
                            Text("\(medicationEntry.medication.name) - \(medicationEntry.status.rawValue)")
                                .font(.subheadline)
                        }
                    }
                    } else if(DoubleDateFormatted() >= currentDate_double){
                        if let medications = medicationHistory[currentDate_week] {
                            ForEach(medications, id: \.self) { medicationEntry in
                                Text("\(medicationEntry.medication.name) - \(medicationEntry.medication.time)")
                                    .font(.subheadline)
                            }
                    }
                    //Past info
                    
                }
                
            }.onTapGesture {
                let selected_date_double: Double = DoubleDateFormatted()
                print(selected_date_double)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }.padding(.bottom, 600)
        .onAppear {
            
            // Initialize dummy medication history
            let currentDate_double: Double =  Double(formatterDouble.string(from: currentDate)) ?? 0 // Move this line here
            print(currentDate_double)
            let currentDate_week: String = formatter.string(from: currentDate)
            print(currentDate_week)
            let selected_date_double = DoubleDateFormatted()
            print(selected_date_double)
            initializeMedicationHistory()
        }
    }
    
    private func dateForDay(index: Int) -> Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        return calendar.date(byAdding: .day, value: index, to: startOfWeek)!
    }
    
    private func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Day of the week abbreviated
        return formatter.string(from: date)
    }
    
    private func dayOfMonth(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Day of the month
        return formatter.string(from: date)
    }
    
    // Format selected date for accessing medication history
    private func selectedDateFormatted() -> String {
        guard let selectedDate = selectedDate else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    private func DoubleDateFormatted() -> Double {
        guard let selectedDate = selectedDate else {
            return 0 // Return default value if selectedDate is nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return Double(formatter.string(from: selectedDate)) ?? 0
    }
    
    // Initialize dummy medication history
    private func initializeMedicationHistory() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Dummy medication history for each day of the week
        medicationHistory = [
            formatter.string(from: currentDate): [
                MedicationEntry(medication: Medicine(name: "Aspirin", dosage: "100mg", time: "Morning"), status: .takenOnTime),
                MedicationEntry(medication: Medicine(name: "Ibuprofen", dosage: "200mg", time: "Evening"), status: .missed),
            ],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!): [
                MedicationEntry(medication: Medicine(name: "Tylenol", dosage: "50mg", time: "Morning"), status: .takenOnTime),
                MedicationEntry(medication: Medicine(name: "Aspirin", dosage: "150mg", time: "Evening"), status: .takenLate),
            ],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: currentDate)!): [
                MedicationEntry(medication: Medicine(name: "Ibuprofen", dosage: "100mg", time: "Morning"), status: .takenOnTime),
            ],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: currentDate)!): [
                MedicationEntry(medication: Medicine(name: "Tylenol", dosage: "100mg", time: "Morning"), status: .takenOnTime),
                MedicationEntry(medication: Medicine(name: "Aspirin", dosage: "150mg", time: "Evening"), status: .missed),
            ],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 4, to: currentDate)!): [
                MedicationEntry(medication: Medicine(name: "Aspirin", dosage: "100mg", time: "Morning"), status: .missed),
                MedicationEntry(medication: Medicine(name: "Ibuprofen", dosage: "200mg", time: "Evening"), status: .takenLate),
            ],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 5, to: currentDate)!): [
                MedicationEntry(medication: Medicine(name: "Ibuprofen", dosage: "200mg", time: "Morning"), status: .takenLate),
                MedicationEntry(medication: Medicine(name: "Aspirin", dosage: "100mg", time: "Evening"), status: .takenOnTime),
            ],
            formatter.string(from: Calendar.current.date(byAdding: .day, value: 6, to: currentDate)!): [
                MedicationEntry(medication: Medicine(name: "Aspirin", dosage: "100mg", time: "Morning"), status: .takenOnTime),
                MedicationEntry(medication: Medicine(name: "Tylenol", dosage: "50mg", time: "Evening"), status: .missed),
            ]
        ]
    }
}

struct Medicine: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let dosage: String
    let time: String
}

// Enum to represent medication status
enum MedicationStatus: String {
    case takenOnTime = "Taken on time"
    case takenLate = "Taken late"
    case missed = "Missed"
}

// Struct to represent medication entry
struct MedicationEntry: Hashable {
    let medication: Medicine
    let status: MedicationStatus
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(medication)
        hasher.combine(status)
    }
    
    static func == (lhs: MedicationEntry, rhs: MedicationEntry) -> Bool {
        return lhs.medication == rhs.medication && lhs.status == rhs.status
    }
}



