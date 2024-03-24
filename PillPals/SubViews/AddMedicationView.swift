//
//  AddMedicationView.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/10/23.
//

import Foundation
import SwiftUI
import Combine
import CoreData

struct AddMedicationView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var selectedType: MedicationType = .pill
    @State private var selectedMedicationPeriod: MedicationPeriod = .morning
    @State private var priority: Priority = .normal
    @State private var dosageAmountString: String = ""
    private var dosageAmount: Double {
        return Double(dosageAmountString) ?? 0
    }
    @State private var selectedDaysOfWeek: [Int] = []
    @State private var selectedDosageUnit: DosageUnit = .milligram
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedWeekDays: [DayOfWeek] = []
    @State private var timeToTake = Date()
    @State private var color: Color = Color(red: 180.0/255.0, green: 200.0/255.0, blue: 220.0/255.0)
    
    var bounds: Range<Date> {
        let start = min(startDate, endDate)
        let end = max(startDate, endDate)
        return start..<Calendar.current.date(byAdding: .day, value: 1, to: end)!
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
                    Picker("Dosage Unit", selection: $selectedDosageUnit) {
                        ForEach(DosageUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    DatePicker("Time to Take", selection: $timeToTake, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Select Time", selection: $timeToTake, displayedComponents: .hourAndMinute)
                        .onChange(of: timeToTake) { _ in
                            assignMedicationPeriodBasedOnTime()
                            updateSelectedDates()
                        }
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])
                        .onChange(of: startDate) { newValue in
                            if newValue > endDate {
                                endDate = newValue
                            }
                            updateSelectedDates()
                        }
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
                        .onChange(of: endDate) { newValue in
                            if newValue < startDate {
                                startDate = newValue
                            }
                            updateSelectedDates()
                        }
                    
                    Button("Choose Days") {
                        showingDaySelection = true
                    }
                    .sheet(isPresented: $showingDaySelection) {
                        DaySelectionView(selectedDays: $selectedWeekDays)
                            .onDisappear {
                                updateSelectedDates()
                            }
                    }
                    
                    Section(header: Text("Selected Days")) {
                        if !selectedWeekDays.isEmpty {
                            SelectedDaysView(selectedDays: selectedWeekDays)
                        }
                    }
                    // MultiDatePicker("Select Dates", selection: $selectedDates, in: bounds)
                }
            }
            .navigationBarTitle("Add Medication", displayMode: .inline)
            .navigationBarItems(leading: Button("Create") {
                createMedication()
            }, trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func createMedication() {
        let newMedication = Medication(context: moc)
        newMedication.id = UUID()
        newMedication.name = name
        newMedication.type = selectedType.rawValue
        newMedication.dosage = createDosage(amount: dosageAmount, unit: selectedDosageUnit)
        newMedication.dateStatusArray = selectedDates
        // Convert DayOfWeek values to their calendarValue integers and store
        // let dayNumbers: [Int] = selectedWeekDays.map { $0.calendarValue }
        let dayNumbersString = selectedWeekDays.map { String($0.calendarValue) }.joined(separator: ",")
        newMedication.daysOfWeek = dayNumbersString
        newMedication.startDate = startDate
        newMedication.endDate = endDate
        newMedication.timeToTake = timeToTake
        // newMedication.color = RGBColor(color: color)
        newMedication.priority = priority.rawValue
        newMedication.imageName = "pills"
        newMedication.period = selectedMedicationPeriod.rawValue

        do {
            try moc.save()
            NotificationManager.shared.scheduleNotificationsForMedication(newMedication)
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving medication: \(error)")
        }
    }

    private func createDosage(amount: Double, unit: DosageUnit) -> Dosage {
        let dosage = Dosage(context: moc)
        dosage.amount = amount
        dosage.unit = unit.rawValue
        return dosage
    }

    @State private var selectedDates: [MedicationDateStatus] = []

    private func updateSelectedDates() {
        selectedDates.removeAll()
        var currentDate = startDate

        let calendar = Calendar.current

        while currentDate <= endDate {
            let weekDay = calendar.component(.weekday, from: currentDate)
            // Convert the DayOfWeek enum values to comparable weekday integers.
            let selectedWeekDayNumbers = selectedWeekDays.map { $0.calendarValue }

            if selectedWeekDayNumbers.contains(weekDay) {
                let combinedDateTime = combineDateWithTime(date: currentDate, time: timeToTake)
                let dateStatus = MedicationDateStatus(context: moc)
                dateStatus.date = combinedDateTime
                dateStatus.taken = false
                selectedDates.append(dateStatus)
            }

            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            if currentDate > endDate {
                break
            }
        }
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

    private func assignMedicationPeriodBasedOnTime() {
        let hour = Calendar.current.component(.hour, from: timeToTake)

        switch hour {
        case 5..<10:
            selectedMedicationPeriod = .morning
        case 10..<16:
            selectedMedicationPeriod = .daytime
        case 16..<19:
            selectedMedicationPeriod = .evening
        case 19...23, 0..<5:
            selectedMedicationPeriod = .night
        default:
            selectedMedicationPeriod = .daytime
        }
    }

    @State private var showingDaySelection = false
}
