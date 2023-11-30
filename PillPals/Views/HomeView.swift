//
//  HomeView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/21/23.
//

import Foundation
import SwiftUI
import AppIntents
import UserNotifications
import UserNotificationsUI

/*struct Medication: Identifiable {
    var id = UUID()
    var color: Color
    var name: String
    var dosage: String
    var time: String
    var period: MedicationPeriod
}*/

let demoUser = UserInfo(name: "John", age: 55)

func timeString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a" // This format sets the time in the 12-hour format with AM/PM
    return formatter.string(from: date)
}

struct HomeView: View {
    // Example medications
    //@State private var medications: [Medication] = dummyMedications
    //@StateObject var medications = MedStore()
    
    @State private var showingAddMedicationView = false
    @Binding var meds: [Medication]
    @Environment(\.scenePhase) private var scenePhase
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?
    @State private var medicationToDelete: Medication?

    
    let saveAction: ()->Void


    @State private var homeViewDemoUser: UserInfo = demoUser
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(meds) { medication in
                        NavigationLink(destination: MedicationDetailView(medication: medication)) {
                            MedicationView(medication: medication) {
                                indexSetToDelete = meds.firstIndex(where: { $0.id == medication.id }).map { IndexSet(integer: $0) }
                                showDeleteConfirmation = true
                            }
                        }
                    }
                    .onDelete(perform: deleteMedication)
                }
                .padding()
                
                VStack {
                    Button("Request Permission") {
                                requestNotificationPermission()
                    }

                    Button("Schedule Notifications for Medications") {
                        scheduleMedicationNotifications()
                    }
                }
            }
            .navigationTitle("Hello " + homeViewDemoUser.name + "!")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton() // Add this line for the Edit button
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMedicationView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView(medications: $meds) { newMedication in
                // Logic to schedule notification for newMedication
                scheduleNotificationsForMedication(newMedication)
            }
        }
        .alert(isPresented: $showDeleteConfirmation) {
                    Alert(
                        title: Text("Delete Medication"),
                        message: Text("Are you sure you want to delete this medication?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let indexSet = indexSetToDelete {
                                withAnimation(.easeOut) {
                                    
                                    meds.remove(atOffsets: indexSet)
                                

                                    // Optional: Include your save action or update to persistent storage here
                                }
                            
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
    
    private func deleteMedication(at offsets: IndexSet) {
        indexSetToDelete = offsets
        showDeleteConfirmation = true
    }
    
}

struct MedicationView: View {
    var medication: Medication
    var onDelete: () -> Void  // Closure for handling delete action

    var body: some View {
        VStack(alignment: .leading) {
            

            Text(timeString(from: medication.timeToTake))
                .font(.headline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: medication.period.rawValue)
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
                Button(action: onDelete) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    
                
                
            }
            .padding()
            .background(medication.uiColor.opacity(0.3))
            .cornerRadius(12)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(meds: .constant(dummyMedications), saveAction: {})
    }
}


func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}

func scheduleMedicationNotifications() {

    for medication in dummyMedications {
        scheduleNotificationsForMedication(medication)
    }
}

func scheduleNotificationsForMedication(_ medication: Medication) {
    // Iterate through the dates and check if the day of the week matches
    var date = medication.startDate
    while date <= medication.endDate {
        if medication.daysOfWeekToTake.contains(date.dayOfWeek) {
            let notificationDate = Calendar.current.date(bySettingHour: medication.timeToTake.hour, minute: medication.timeToTake.minute, second: 0, of: date)!
            scheduleNotification(at: notificationDate, title: "Time to take your \(medication.name)", body: "Dosage: \(medication.dosage.amount) \(medication.dosage.unit)")
        }
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
}

func scheduleNotification(at date: Date, title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default

    let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}


// Extension to get day of week from Date
extension Date {
    var dayOfWeek: DayOfWeek {
            let weekday = Calendar.current.component(.weekday, from: self)
            return DayOfWeek.allCases.first { $0.calendarValue == weekday }!
        }

    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
}

/*struct ShowUpcomingMedication: AppIntent {
    
    let dummy: Medication =
        Medication(
            name: "Pilly",
            type: .tablet,
            dosage: Dosage(amount: 5, unit: .milligrams),
            datesToTake: createDummyMedicationDates(startDate: startDate, endDate: endDate, daysOfWeek: dummyDaysOfWeek),

            daysOfWeekToTake: dummyDaysOfWeek,
            startDate: startDate,
            endDate: endDate,
            timeToTake: dummyTimeToTake1,
            color: .red,
            priority: .normal,
            imageName: "pills",
            period: MedicationPeriod.morning
        )
    static var title: LocalizedStringResource = "Open Home"
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return MedicationView(medication: dummy )
    }
}*/

