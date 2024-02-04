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
import Combine

let demoUser = UserInfo(name: "John", age: 55)

func timeString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a" // This format sets the time in the 12-hour format with AM/PM
    return formatter.string(from: date)
}

// MARK: - HomeView
/// The main view of the app - retrieves all medications from local storage if present.
/// Provides navigation capability to the detail view
/// Allows addition of new meds (AddMedicationView) and deletion
/// Automatically creates and handles notifcation creation

struct HomeView: View {
    // Example medications
    //@State private var medications: [Medication] = dummyMedications
    @StateObject var medications = MedStore()
    @StateObject var notificationManager = NotificationManager.shared
    @State private var showingAddMedicationView = false
    @Binding var meds: [Medication]
    @Environment(\.scenePhase) private var scenePhase
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?
    @State private var medicationToDelete: Medication?
    @State private var showingLogSheet = false
    @State private var medicationToLog: Medication?
    @State private var selectedMedicationId: String?
    @State private var showingLogMedicationView = false
    
    let saveAction: ()->Void
    
    /*var sortedMeds: [Medication] {
        meds.sorted { $0.timeToTake < $1.timeToTake}
    }*/

    
    @State private var homeViewDemoUser: UserInfo = demoUser
    var body: some View {
        // used to be NavigationStack
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(meds.sorted { $0.timeToTake < $1.timeToTake}) { medication in
                        NavigationLink(destination: MedicationDetailView(medication: medication)) {
                            MedicationView(medication: medication) {
                                indexSetToDelete = meds.firstIndex(where: { $0.id == medication.id }).map { IndexSet(integer: $0) }
                                showDeleteConfirmation = true
                            }
                        }
                        .transition(.fadeOut) // Apply custom transition here
                        
                    }
                    .onDelete(perform: deleteMedication)
                }
                .padding()
            }
            /*.onReceive(NotificationManager.shared.medicationNotification) { medicationId in
             if let medication = meds.first(where: { $0.id.uuidString == medicationId }) {
             medicationToLog = medication
             showingLogSheet = true
             }
             }
             .sheet(isPresented: $showingLogSheet) {
             if let medication = medicationToLog {
             LogMedicationSheet(medication: medication, isPresented: $showingLogSheet)
             }
             }*/
            .navigationTitle("Hello " + homeViewDemoUser.name + "!")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Add this line for the Edit button
                    //EditButton()
                    
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
        .onAppear {
            notificationManager.checkPendingNotification()
            
        }
        .onChange(of: notificationManager.selectedMedicationId) { newId in
            if let newId = newId, newId != selectedMedicationId {
                selectedMedicationId = newId
                showingLogMedicationView = true
            }
        }
        /// Presents a sheet to log medication. - doesnt work tho
        .sheet(isPresented: $showingLogMedicationView) {
            if let medication = getMedicationById(selectedMedicationId) {
                LogMedicationSheet(medication: medication, isPresented: $showingLogMedicationView)
            }
        }
        .sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView(medications: $meds) { newMedication in
                NotificationManager.shared.scheduleNotificationsForMedication(newMedication)
                meds.sort { $0.timeToTake < $1.timeToTake }
                print("Medications sorted: \(meds.map { $0.name })")
            }
        }
        .sheet(isPresented: $showingLogSheet) {
            if let medication = medicationToLog {
                
                LogMedicationSheet(medication: medication, isPresented: $showingLogSheet)
            }
        }
        /// Deletes a medication from the view, data
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Medication"),
                message: Text("Are you sure you want to delete this medication?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let indexSet = indexSetToDelete {
                        withAnimation {
                            meds.remove(atOffsets: indexSet)
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
    func presentLogSheet(for medication: Medication) {
        medicationToLog = medication
        showingLogSheet = true
    }
    private func deleteMedication(at offsets: IndexSet) {
        offsets.forEach { index in
            let medication = meds[index]
            NotificationManager.shared.cancelNotifications(for: medication.id)
        }
        meds.remove(atOffsets: offsets)
    }
    func getMedicationById(_ id: String?) -> Medication? {
        // Implement logic to find and return the Medication object
        guard let idString = id, let uuid = UUID(uuidString: idString) else {
            return nil
        }
        return meds.first {$0.id == uuid}
    }
    
}



// MARK: - MedicationView

/// A view representing a single medication in the list.

struct MedicationView: View {
    var medication: Medication
    var onDelete: () -> Void  // Closure for handling delete action
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(medication.timeToTake, style: .time)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.gray).opacity(0.5)
                    .cornerRadius(8)
                
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(medication.color.color)
                    .imageScale(.large)
            }
            /*Text(timeString(from: medication.timeToTake))
             .font(.headline)
             .foregroundColor(.secondary)*/
            
            
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
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                
                
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(medication.uiColor.opacity(0.5)))
            //.fill(reminder.isTaken ? .secondary : reminder.uiColor.opacity(0.3)))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(medication.uiColor, lineWidth: 2)
            )
        }
        .padding(.vertical, 4)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(meds: .constant(dummyMedications), saveAction: {})
    }
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

// MARK: - LogMedicationSheet

/// A sheet view for logging medication intake.
struct LogMedicationSheet: View {
    var medication: Medication
    @Binding var isPresented: Bool
    @State private var showReminderOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Medication: \(medication.name)")
                Text("Dosage: \(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                Text("Today's Date: \(Date(), formatter: LogMedicationSheet.dateFormatter)")
                
                Button("Mark as Taken") {
                    markMedicationAsTaken()
                    isPresented = false
                }
                
                Button("Mark as Not Taken") {
                    // Handle not taken action
                    isPresented = false
                }
                
                Button("Remind Me") {
                    showReminderOptions = true
                }
                
                Spacer()
            }
            .navigationTitle("Medication Details")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
        .sheet(isPresented: $showReminderOptions) {
            ReminderOptionsView(medication: medication, isPresented: $showReminderOptions)
        }
    }
    
    private func markMedicationAsTaken() {
        // Logic to mark medication as taken
    }
    /// DateFormatter for displaying the date in the sheet.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}

struct ReminderOptionsView: View {
    var medication: Medication
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            Button("In 30 Minutes") { scheduleReminder(minutes: 30) }
            Button("In 1 Hour") { scheduleReminder(minutes: 60) }
            Button("In 2 Hours") { scheduleReminder(minutes: 120) }
            // Add more options as needed
        }
        .navigationTitle("Set Reminder")
    }
    
    private func scheduleReminder(minutes: Int) {
        let reminderDate = Calendar.current.date(byAdding: .minute, value: minutes, to: Date())!
        NotificationManager.shared.scheduleNotification(medication: medication, at: reminderDate, title: "Reminder: \(medication.name)", body: "It's time to take your medication.")
        isPresented = false
    }
}


// MARK: - NotificationManager

/// A singleton class to manage notifications for the app.
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published var selectedMedicationId: String? // This should be String?
    
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else if let error = error {
                print("Notification permissions error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(medication: Medication, at date: Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.userInfo = ["medicationID": medication.id.uuidString]
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notifcation: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        processNotification(notification)
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        processNotification(response.notification)
        completionHandler()
    }
    
    // Call this method when the app becomes active
    func checkPendingNotification() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            if let firstNotification = notifications.first(where: { $0.request.content.userInfo["medicationId"] != nil }),
               let medicationId = firstNotification.request.content.userInfo["medicationId"] as? String {
                DispatchQueue.main.async {
                    self.selectedMedicationId = medicationId
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [firstNotification.request.identifier])
                }
            }
        }
    }
    func cancelNotifications(for medicationId: UUID) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let idsToCancel = requests.filter {
                $0.content.userInfo["medicationId"] as? String == medicationId.uuidString
            }.map { $0.identifier }
            
            center.removePendingNotificationRequests(withIdentifiers: idsToCancel)
        }
    }
    private func processNotification(_ notification: UNNotification) {
        if let medicationID = notification.request.content.userInfo["medicationId"] as? String {
            DispatchQueue.main.async {
                self.selectedMedicationId = medicationID
            }
        }
    }
}

extension NotificationManager {
    func scheduleNotificationsForMedication(_ medication: Medication) {
        var date = medication.startDate
        while date <= medication.endDate {
            if medication.daysOfWeekToTake.contains(date.dayOfWeek) {
                let notificationDate = Calendar.current.date(bySettingHour: medication.timeToTake.hour, minute: medication.timeToTake.minute, second: 0, of: date)!
                scheduleNotification(medication: medication, at: notificationDate, title: "Time to take your \(medication.name)", body: "Dosage: \(medication.dosage.amount) \(medication.dosage.unit)")
            }
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
    }
}

extension AnyTransition {
    static var fadeOut: AnyTransition {
        .asymmetric(insertion: .identity, removal: .opacity)
    }
}


