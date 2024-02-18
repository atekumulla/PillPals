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
    @State private var showingCaregiverView = false
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
    
    // Organizes medications by period and sorts them within each period
    // Organizes medications by period and sorts them within each period by time
    private var sortedMedicationsByPeriod: [MedicationPeriod: [Medication]] {
        let today = Calendar.current.component(.weekday, from: Date())
        
        // Filter medications for today
        let medicationsForToday = medStore.meds.filter { medication in
            medication.daysOfWeekToTake.contains(where: { $0.calendarValue == today })
        }
        
        // Group and sort medications by period
        let grouped = Dictionary(grouping: medicationsForToday) { $0.period }
        
        // Sort each group first by time and then by name within each period
        let sortedGroups = grouped.mapValues { medications in
            medications.sorted {
                if $0.timeToTake == $1.timeToTake {
                    return $0.name < $1.name // Secondary sort by name if times are equal
                }
                return $0.timeToTake < $1.timeToTake // Primary sort by time
            }
        }
        
        return sortedGroups
    }

    
    
    var body: some View {
        // used to be NavigationStack
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(MedicationPeriod.allCases, id: \.self) { period in
                        if let periodMedications = sortedMedicationsByPeriod[period] {
                            ForEach(periodMedications) { medication in
                                
                                NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                    MedicationView(medication: medication) {
                                        indexSetToDelete = medStore.meds.firstIndex(where: { $0.id == medication.id }).map { IndexSet(integer: $0) }
                                        showDeleteConfirmation = true
                                    }
                                    
                                }
                                .transition(.fadeOut) // Apply custom transition here
                            }
                        }
                    }
                    .onDelete(perform: deleteMedication)
                }
                .padding()
            }
            //.background(Color.gray.opacity(0.3))
            .navigationTitle("Hello " + homeViewDemoUser.name + "!")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Add this line for the Edit button
                    //EditButton()
                    Button(action: {
                        showingCaregiverView = true
                    }) {
                        Image(systemName: "person.badge.key.fill")
                    }
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
        .sheet(isPresented: $showingCaregiverView) {
            CaregiverView()
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
    
    // Example function to determine if the medication was taken on a specific day
    // This function would need to be implemented based on your app's data structure
    func isMedicationTakenToday() -> Bool {
        // Lookup logic to determine if medication was taken today
        // This is just a placeholder and needs to be replaced with actual logic
        // For example, you might check today's date against the medication.datesToTake array
        return medication.datesToTake.contains { $0.date == Date() && $0.taken }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(medication.timeToTake, style: .time)
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(.regularMaterial).opacity(0.8)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                   Text("More Info")
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(.regularMaterial).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .cornerRadius(8)
                }
                .padding([.top, .horizontal])
                
                //Divider()  // Adds a divider between the time/checkmark and the medication details
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(medication.color.color.opacity(1.0))
                    .padding(.horizontal)
                    
                
                HStack {
                    Image(systemName: medication.period.rawValue)
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black.opacity(0.7))
                        .imageScale(.large)
                    
                    VStack(alignment: .leading) {
                        Text(medication.name)
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                        Text("\(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding([.bottom, .horizontal])
            }
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(medication.color.color.opacity(0.7))
                .shadow(color: medication.color.color, radius: 0, x: 0, y: 0)) // Apply shadow here)
            /*.overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(medication.color.color, lineWidth: 2)
            )*/
        }
        .padding(.vertical, 4)
    }
}

let sampleColor: Color = Color(
    red: 180.0/255.0,
    green: 200.0/255.0,
    blue:  240.0/255.0
)
let rgbSampleColor = RGBColor(color: sampleColor)

struct MedicationView_Previews: PreviewProvider {
    var onDelete: () -> Void  // Closure for handling delete action
    static var previews: some View {
        MedicationView(medication: dummyMed, onDelete: {
                    // Implement your delete action or leave it empty for preview purposes
                    print("Delete action triggered")
                })    }
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

