//
//  AddMedicationView.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/10/23.
//

import Foundation
import SwiftUI


struct AddMedicationView: View {
    @Binding var medications: [Medication]
    //@State var medications: [Medication] = dummyMedications
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var selectedType = MedicationType.pill
    @State private var color: Color = Color.red // Default to red or any color
    @State private var priority: Priority = .normal
    @State private var dateToTake = Date()
    
    @State private var selectedDatesComponents: Set<DateComponents> = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var selectedDates: [Date] = []
    
    @State private var showingDaySelection = false
    @State private var selectedWeekDays: [DayOfWeek] = []
    
    @State private var timeToTake = Date() // Default to current time


        
    var bounds: Range<Date> {
        return startDate..<endDate
    }
    
    var range: Int {
        let startDay = Calendar.current.component(.day, from: startDate)
        let endDay = Calendar.current.component(.day, from: endDate)
        
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        let numberOfDays = components.day ?? 0
        
        return numberOfDays+1
    }

    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Info")) {
                    TextField("Medication Name", text: $name)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(MedicationType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    
                    ColorPicker("Choose Color", selection: $color)

                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                        
                        DatePicker("Time to Take", selection: $timeToTake, displayedComponents: .hourAndMinute)
                    }
                }
                
                
               // DatePicker("Date to Take", selection: $dateToTake, displayedComponents: .date)
                Section(header: Text("Date")) {
                    Text("Selected Dates: \(range)")
                        .font(.title)
                    
                    
                    /*DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])*/
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                        .onChange(of: startDate) { _ in
                            updateSelectedDates()
                        }

                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                        .onChange(of: endDate) { _ in
                            updateSelectedDates()
                        }
                    
                    Button("Choose Days") {
                        showingDaySelection = true
                    }
                    .sheet(isPresented: $showingDaySelection) {
                        DaySelectionView(selectedDays: $selectedWeekDays)
                            .onDisappear() {
                                updateSelectedDates()
                            }
                    }
                    
                    Section(header: Text("Selected Days")) {
                        if !selectedWeekDays.isEmpty {
                                            SelectedDaysView(selectedDays: selectedWeekDays)
                                        }
                    }
                    
                    
                    
                    MultiDatePicker("Select Dates", selection: $selectedDatesComponents, in: bounds)
                    
                    // View to display selected days
                    /*if !selectedWeekDays.isEmpty {
                        Text("Selected Days: \(selectedDaysString(selectedWeekDays))")
                            .padding()
                    }*/
                    
                }
                
                
                
                
                
                
                /*Section {
                    
                }*/
                /*ForEach(selectedDates.indices, id: \.self) { index in
                    DatePicker("Select Date and Time", selection: $selectedDates[index], displayedComponents: [.date, .hourAndMinute])
                }*/
                
                
                

                Button("Create") {
                    updateDatesFromDateComponents()
                    updateSelectedDates()
                    updateDatesFromDateComponents()
                    let newMedication = Medication(
                        name: name,
                        type: selectedType,
                        datesToTake: selectedDates,
                        daysOfWeekToTake: selectedWeekDays,
                        startDate: startDate,
                        endDate: endDate,
                        timeToTake: timeToTake,
                        color: color,
                        priority: priority,
                        imageName: "pills" // Default image name
                    )
                    medications.append(newMedication)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Add Medication", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    private func selectedDaysString(_ days: [DayOfWeek]) -> String {
            days.map { $0.title }.joined(separator: ", ")
        }
    
    private func updateDateComponentsFromDates() {
        selectedDatesComponents = Set(selectedDates.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) })
    }

    private func updateDatesFromDateComponents() {
        selectedDates = selectedDatesComponents.compactMap { Calendar.current.date(from: $0) }
    }
    
    private func calculateDatesBetween(startDate: Date, endDate: Date, selectedWeekDays: [DayOfWeek]) -> Set<DateComponents> {
        var dates: Set<DateComponents> = []
        var currentDate = startDate

        let calendar = Calendar.current

        while currentDate <= endDate {
            let weekDay = calendar.component(.weekday, from: currentDate)

            if selectedWeekDays.contains(where: { $0.calendarValue == weekDay }) {
                let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                dates.insert(components)
            }

            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }

        return dates
    }
    
    private func updateSelectedDates() {
        selectedDates.removeAll() // Clear the existing dates
        var currentDate = startDate

        let calendar = Calendar.current

        while currentDate <= endDate {
            let weekDay = calendar.component(.weekday, from: currentDate)

            // Check if the current day's weekday matches any of the selected weekdays
            if selectedWeekDays.contains(where: { $0.calendarValue == weekDay }) {
                selectedDates.append(currentDate)
            }

            // Move to the next day
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        selectedDatesComponents = Set(selectedDates.map { calendar.dateComponents([.year, .month, .day], from: $0) })

    }



    // Call this function whenever the start date, end date, or selected days change
    /*private func updateSelectedDates() {
        selectedDatesComponents = calculateDatesBetween(startDate: startDate, endDate: endDate, selectedWeekDays: selectedWeekDays)
    }*/

}


