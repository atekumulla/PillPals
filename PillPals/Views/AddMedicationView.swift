//
//  AddMedicationView.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/10/23.
//

import Foundation
import SwiftUI
import Combine

struct AddMedicationView: View {
    @Binding var medications: [Medication] // = dummyMedications
    //@State var medications: [Medication] = dummyMedications
    /// Once create or edit button are pressed, and their respective views are interactied with, this variable
    /// handles the removal of those views from the neviornment
    @Environment(\.presentationMode) var presentationMode
    
    /// These next few create local variables which the user assigns values for by choosing them in the form
    ///  later these are lumped together to create the actual medication
    @State private var name: String = ""
    @State private var selectedType = MedicationType.pill
    @State private var selectedMedicationPeriod = MedicationPeriod.morning
    @State private var color: Color = Color.red // Default to red or any color
    @State private var priority: Priority = .normal
    @State private var dateToTake = Date()
    @State private var dosageAmountString: String = ""
        private var dosageAmount: Double {
            return Double(dosageAmountString) ?? 0
    }

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
    

    
    /// The MultiDatePicker allows a Calendar view where one can see/select multiple dates
    ///  The current logic works as follows:
    ///  First, you select the start and endDate - these act as the dates that bound the multiview
    ///  As a result, once the start and end date have been slected, all other days are grayed out - inactive
    var bounds: Range<Date> {
        return startDate..<endDate
    }
    
    // IGNORE
    var range: Int {
        
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        let numberOfDays = components.day ?? 0
        
        return numberOfDays+1
    }
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()



    var body: some View {
        
        /// NavigationView: A view for presenting a stack of views that represents a visible path in a navigation hierarchy.
        ///  Deprecated might need to change
        NavigationView {
            /// List: A view that presents rows of data in column, with options to have multiple column
            List {
                /// FIrst section handles basic info
                Section(header: Text("Info")) {
                    TextField("Medication Name", text: $name)
                        .submitLabel(.return)
                    
                    /// Iterates through all types of medication
                    Picker("Type", selection: $selectedType) {
                        ForEach(MedicationType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    
                    TextField("Dosage Amount", text: $dosageAmountString)
                        .keyboardType(.decimalPad)
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                        .onReceive(Just(dosageAmountString)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.dosageAmountString = filtered
                            }
                        }

                    
                    
                    
                    /// Iterates through dosage counts
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
                    
                    /// Select start and end time. At the same time updates w.r.t MultiDatePicker
                    DatePicker("Select Time", selection: $timeToTake, displayedComponents: .hourAndMinute)
                        .onChange(of: timeToTake) { _ in
                            updateSelectedDates()
                        }
                    
                    
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                        .onChange(of: startDate) { _ in
                            updateSelectedDates()
                        }
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                        .onChange(of: endDate) { _ in
                            updateSelectedDates()
                        }
                    
                    /// Onse selected, opens the sheet which shows the days of weeks
                    /// Once days chosen, and view is dismissed, updates dates w.r.t MultiDatePicker
                    Button("Choose Days") {
                        showingDaySelection = true
                    }
                    .sheet(isPresented: $showingDaySelection) {
                        DaySelectionView(selectedDays: $selectedWeekDays)
                            .onDisappear() {
                                updateSelectedDates()
                            }
                    }
                    
                    /// Visually shows Selected days
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
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    /// Once create Button is trigger, intializes a Medication Object with chosen values, appens to medications array (which async updates storage) and calls an empty func (for syntax reasons)
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
    
    /// clears dates, while StartDate is less than or equal to end, combines date and time, created MedicationDateStatus object
    private func updateSelectedDates() {
        selectedDates.removeAll() // Clear the existing dates
        var currentDate = startDate
        
        let calendar = Calendar.current
        
        while currentDate <= endDate {
            let weekDay = calendar.component(.weekday, from: currentDate)
            
            // Check if the current day's weekday matches any of the selected weekdays
            if selectedWeekDays.contains(where: { $0.calendarValue == weekDay }) {
                let combinedDateTime = combineDateWithTime(date: currentDate, time: timeToTake)
                
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
    
    /// Merges the date and time into one Date object
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


