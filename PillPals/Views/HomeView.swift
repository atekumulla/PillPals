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
    @State private var showingLogSheet = false
    @State private var medicationToLog: Medication?
    
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
                    Button("Schedule Notifications for Medications") {
                        scheduleMedicationNotifications()
                    }
                }
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
        /*.sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView(medications: $meds) { newMedication in
                // Logic to schedule notification for newMedication
                scheduleNotificationsForMedication(newMedication)
            }
        }*/
        .sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView(medications: $meds) { newMedication in
                NotificationManager.shared.scheduleNotificationsForMedication(newMedication)
            }
        }
        .sheet(isPresented: $showingLogSheet) {
            if let medication = medicationToLog {
                LogMedicationSheet(medication: medication, isPresented: $showingLogSheet)
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
    func presentLogSheet(for medication: Medication) {
            medicationToLog = medication
            showingLogSheet = true
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
            HStack {
                Text(medication.timeToTake, style: .time)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.gray)
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
            scheduleNotification(medication: medication, at: notificationDate, title: "Time to take your \(medication.name)", body: "Dosage: \(medication.dosage.amount) \(medication.dosage.unit)")
        }
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
}

func scheduleNotification(medication: Medication, at date: Date, title: String, body: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    content.userInfo = ["medicationId": medication.id.uuidString] // Example key-value pair


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

struct LogMedicationSheet: View {
    var medication: Medication
    @Binding var isPresented: Bool

    var body: some View {
        // Your UI components go here
        // Include the medication information
        // Buttons for "Taken", "Remind Me Later", and "Not Taken"
        VStack {
            MedicationDetailView(medication: medication)
        }
    }

    private func handleTaken() {
        // Handle medication taken action
        isPresented = false
    }

    private func handleRemindMeLater() {
        // Schedule a new notification
    }

    private func handleNotTaken() {
        // Handle medication not taken action
        isPresented = false
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



/*class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published var selectedMedicationId: String?

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
        content.userInfo = ["medicationId": medication.id.uuidString]

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
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

    private func processNotification(_ notification: UNNotification) {
        if let medicationId = notification.request.content.userInfo["medicationId"] as? String {
            DispatchQueue.main.async {
                self.selectedMedicationId = medicationId
            }
        }
    }
}*/


/*class NotificationManager: ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    let medicationNotification = PassthroughSubject<String, Never>()

    init() {
        UNUserNotificationCenter.current().delegate = self
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        processNotification(notification)
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        processNotification(response.notification)
        completionHandler()
    }

    private func processNotification(_ notification: UNNotification) {
        if let medicationId = notification.request.content.userInfo["medicationId"] as? String {
            medicationNotification.send(medicationId)
        }
    }
}*/



class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    @Published var selectedMediationId: String?
    
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
    
    
    private func processNotification(_ notification: UNNotification) {
        if let medicationID = notification.request.content.userInfo["medicationId"] as? String {
            DispatchQueue.main.async {
                self.selectedMediationId = medicationID
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
