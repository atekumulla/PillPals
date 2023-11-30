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
    @State private var selectedMedicationPeriod = MedicationPeriod.morning
    @State private var color: Color = Color.red // Default to red or any color
    @State private var priority: Priority = .normal
    @State private var dateToTake = Date()
    
    @State private var dosageAmount: Double = 0
    @State private var selectedDosageUnit: Dosage.Unit = .count
    
    @State private var selectedDatesComponents: Set<DateComponents> = []
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    @State private var selectedDates: [MedicationDateStatus] = []
    
    @State private var showingDaySelection = false
    @State private var selectedWeekDays: [DayOfWeek] = []
    
    @State private var timeToTake = Date() // Default to current time

    @State private var currentDate = Date()
    var onAddMedication: (Medication) -> Void


        
    var bounds: Range<Date> {
        return startDate..<endDate
    }
    
    var range: Int {
        
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
                    
                    TextField("Dosage Amount", value: $dosageAmount, format: .number)
                        .keyboardType(.decimalPad)

                    Picker("Dosage Unit", selection: $selectedDosageUnit) {
                        ForEach(Dosage.Unit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
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
                    Picker("Type", selection: $selectedMedicationPeriod) {
                        ForEach(MedicationPeriod.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    
                    DatePicker("Select Time", selection: $timeToTake, displayedComponents: .hourAndMinute)
                        .onChange(of: timeToTake) { _ in
                            updateSelectedDates()
                        }

                    
                    
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
                    
                }
                
                
                
                
                
                
        
            }
            .navigationBarTitle("Add Medication", displayMode: .inline)
            .navigationBarItems(leading: Button("Create") {
                            createMedication()
                            presentationMode.wrappedValue.dismiss()
                        }, trailing: Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
        }
    }
    
    private func createMedication() {
        let newMedication = Medication(
            name: name,
            type: selectedType,
            dosage: createDosage(amount: dosageAmount, unit: selectedDosageUnit),
            datesToTake: selectedDates,
            daysOfWeekToTake: selectedWeekDays,
            startDate: startDate,
            endDate: endDate,
            timeToTake: timeToTake,
            color: RGBColor(color: color),
            priority: priority,
            imageName: "pills", // Default image name
            period: selectedMedicationPeriod
        )
        //medications.append(newMedication)
        medications.append(newMedication)
        onAddMedication(newMedication)
    }
    private func selectedDaysString(_ days: [DayOfWeek]) -> String {
            days.map { $0.title }.joined(separator: ", ")
    }
    private func createDosage(amount: Double, unit: Dosage.Unit) -> Dosage {
        return Dosage(amount: amount, unit: unit)
    }
    
    /*private func updateDateComponentsFromDates() {
        selectedDatesComponents = Set(selectedDates.map { Calendar.current.dateComponents([.year, .month, .day], from: $0) })
    }

    private func updateDatesFromDateComponents() {
        selectedDates = selectedDatesComponents.compactMap { Calendar.current.date(from: $0) }
    }*/
    
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
                let combinedDateTime = combineDateWithTime(date: currentDate, time: timeToTake)
                
                //             let combinedDateTime = combineDateWithTime(date: currentDate, time: timeToTake)

                let dateStatus = MedicationDateStatus(date: combinedDateTime, taken: false)

                selectedDates.append(dateStatus)
            }

            // Move to the next day
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }
        selectedDatesComponents = Set(selectedDates.map { dateStatus in
                calendar.dateComponents([.year, .month, .day], from: dateStatus.date)
            })
    }


    private func combineDateWithTime(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)

        return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                             minute: timeComponents.minute ?? 0,
                             second: 0,
                             of: date) ?? date
    }

    // Call this function whenever the start date, end date, or selected days change
    /*private func updateSelectedDates() {
        selectedDatesComponents = calculateDatesBetween(startDate: startDate, endDate: endDate, selectedWeekDays: selectedWeekDays)
    }*/

}


