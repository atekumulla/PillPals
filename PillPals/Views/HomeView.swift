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
    @ObservedObject var medStore: MedStore
    @StateObject var notificationManager = NotificationManager.shared
    @State private var showingAddMedicationView = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?
    @State private var medicationToDelete: Medication?
    @State private var showingLogSheet = false
    @State private var medicationToLog: Medication?
    @State private var selectedMedicationId: String?
    @State private var showingLogMedicationView = false
    @State private var homeViewDemoUser: UserInfo = demoUser
    let saveAction: ()->Void
    
    
    func presentLogSheet(for medication: Medication) {
        medicationToLog = medication
        showingLogSheet = true
    }
    private func deleteMedication(at offsets: IndexSet) {
        offsets.forEach { index in
            let medication = medStore.meds[index]
            NotificationManager.shared.cancelNotifications(for: medication.id)
        }
        medStore.meds.remove(atOffsets: offsets)
    }
    func getMedicationById(_ id: String?) -> Medication? {
        // Implement logic to find and return the Medication object
        guard let idString = id, let uuid = UUID(uuidString: idString) else {
            return nil
        }
        return medStore.meds.first {$0.id == uuid}
    }
    
    private func handleAppear() {
        notificationManager.checkPendingNotification()
    }
    
    private func handleSelectedMedicationIdChange(newId: String?) {
        if let newId = newId, newId != selectedMedicationId {
            selectedMedicationId = newId
            showingLogMedicationView = true
        }
    }
    
    
    var body: some View {
        // used to be NavigationStack
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(medStore.meds) { medication in
                        NavigationLink(destination: MedicationDetailView(medication: medication)) {
                            MedicationView(medication: medication) {
                                indexSetToDelete = medStore.meds.firstIndex(where: { $0.id == medication.id }).map { IndexSet(integer: $0) }
                                showDeleteConfirmation = true
                            }
                        }
                        .transition(.fadeOut) // Apply custom transition here
                        
                    }
                    .onDelete(perform: deleteMedication)
                }
                .padding()
            }
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
        .onAppear(perform: handleAppear)
        .onChange(of: notificationManager.selectedMedicationId, perform: handleSelectedMedicationIdChange)
        
        /// Presents a sheet to log medication. - doesnt work tho
        .sheet(isPresented: $showingLogMedicationView) {
            if let medication = getMedicationById(selectedMedicationId) {
                LogMedicationSheet(medication: medication, isPresented: $showingLogMedicationView)
            }
        }
        .sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView(medStore: medStore)
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
                            medStore.meds.remove(atOffsets: indexSet)
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

/*struct HomeView_Previews: PreviewProvider {
 static var previews: some View {
 //HomeView(meds: .constant(dummyMedications), saveAction: {})
 
 }
 }*/




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



extension AnyTransition {
    static var fadeOut: AnyTransition {
        .asymmetric(insertion: .identity, removal: .opacity)
    }
}


