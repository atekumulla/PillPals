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

//let demoUser = UserInfo(name: "ASM", age: 55)

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
    // @EnvironmentObject var medStore: MedStore
    @Environment(\.managedObjectContext) var moc
    /*@FetchRequest(
     sortDescriptors: [NSSortDescriptor(keyPath: \Medication.name, ascending: true)],
     animation: .default
     ) var medications: FetchedResults<Medication>*/
    // Assume `daysOfWeekToTake` is a comma-separated string, e.g., "1,2,3,4,5"
    // The predicate uses wildcards to match the day number within the string correctly.
    
    @FetchRequest var medications: FetchedResults<Medication>
    
    
    @StateObject var notificationManager = NotificationManager.shared
    // @State private var showingAddMedicationView = false
    @State private var showingCaregiverView = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var showDeleteConfirmation = false
    @State private var indexSetToDelete: IndexSet?
    @State private var medicationToDelete: Medication?
    @State private var showingLogSheet = false
    @State private var medicationToLog: Medication?
    @State private var selectedMedicationId: String?
    @State private var showingLogMedicationView = false
    // @State private var homeViewDemoUser: UserInfo = demoUser
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? "User"

    
    init() {
        // Calculate today's index
        let todayIndex = Calendar.current.component(.weekday, from: Date())
        // Ensure searchString correctly matches the stored format
        let searchString = "*\(todayIndex)*"
        
        // Initialize the fetch request
        _medications = FetchRequest<Medication>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Medication.timeToTake, ascending: true)],
            predicate: NSPredicate(format: "daysOfWeek LIKE %@", searchString)
        )
    }
    
    func presentLogSheet(for medication: Medication) {
        medicationToLog = medication
        showingLogSheet = true
    }
    
    /*private func deleteMedication(at offsets: IndexSet) {
     offsets.forEach { index in
     let medication = medStore.meds[index]
     NotificationManager.shared.cancelNotifications(for: medication.id!)
     }
     medStore.meds.remove(atOffsets: offsets)
     }*/
    private func deleteMedications(at offsets: IndexSet) {
        withAnimation {
            offsets.map { medications[$0] }.forEach(moc.delete)
            
            // Save the context
            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getMedicationById(_ id: String?) -> Medication? {
        // Implement logic to find and return the Medication object
        guard let idString = id, let uuid = UUID(uuidString: idString) else {
            return nil
        }
        return medications.first {$0.id == uuid}
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
                    ForEach(MedicationTimeCategory.allCases, id: \.self) { category in
                        VStack {
                            HStack {
                                SectionHeader(category: category)
                            }
                            .font(.title2)
                            .padding(.vertical)
                            
                            let filteredMedications = medications.filter { categorizeMedicationByTime($0) == category }
                            
                            if filteredMedications.isEmpty {
                                /*Text("No medications to take")
                                    .foregroundColor(.gray)
                                    .italic()*/
                                NoMedicationsView() // Custom view for "no medications"
                                                .transition(.scale)
                            } else {
                                ForEach(filteredMedications) { medication in
                                    NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                        MedicationView(medication: medication) {
                                            // Your deletion logic here
                                        }
                                    }
                                    .transition(.opacity)
                                }
                            }
                        }
                        Divider()
                    }
                }
                .padding()
            }
            //.background(Color.gray.opacity(0.3))
            .navigationTitle("Hello!")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Add this line for the Edit button
                    //EditButton()
                    Button(action: {
                        showingCaregiverView = true
                    }) {
                        Image(systemName: "person.badge.key.fill")
                    }
                }
<<<<<<< HEAD
                /*ToolbarItem(placement: .navigationBarTrailing) {
                 Button(action: {
                 showingAddMedicationView = true
                 }) {
                 Image(systemName: "plus")
                 }
                 }*/
=======
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        showingAddMedicationView = true
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
>>>>>>> 38c181ca62634a87272af1e1e34bbcf4f67c45b1
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
        /*.sheet(isPresented: $showingAddMedicationView) {
         AddMedicationView()
         }*/
        .sheet(isPresented: $showingCaregiverView) {
            CaregiverView()
                .environment(\.managedObjectContext, self.moc) // Pass the managedObjectContext explicitly
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
                            // medStore.meds.remove(atOffsets: indexSet)
                            deleteMedications(at: indexSet)
                        }
                        
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                saveContext()
            }
        }
        
    }
    // Define the saveContext function within HomeView
    private func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
    /*func isMedicationTakenToday() -> Bool {
     // Lookup logic to determine if medication was taken today
     // This is just a placeholder and needs to be replaced with actual logic
     // For example, you might check today's date against the medication.datesToTake array
     return medication.datesToTake.contains { $0.date == Date() && $0.taken }
     }*/
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Text(medication.timeToTake!, style: .time)
                        .bold()
                        .foregroundColor(.black)
                        .padding(8)
                        .background(.white).opacity(0.8)
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Text("More Info")
                        .bold()
                        .foregroundStyle(.black)
                        .padding(8)
                        .background(.white).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .cornerRadius(8)
                }
                .padding([.top, .horizontal])
                
                //Divider()  // Adds a divider between the time/checkmark and the medication details
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(sampleColor)
                //foregroundStyle(medication.color.color.opacity(1.0))
                    .padding(.horizontal)
                
                
                HStack {
                    /*Image(systemName: medication.period.rawValue)
                     .aspectRatio(contentMode: .fit)
                     .foregroundColor(.black.opacity(0.7))
                     .imageScale(.large)*/
                    
                    VStack(alignment: .leading) {
                        Text(medication.name!)
                            .font(.largeTitle)
                            .foregroundColor(.black)
                            .bold()
<<<<<<< HEAD
                        Text("\(String(format: "%.1f", medication.dosage!.amount)) \(String(medication.dosage!.unit!))")
=======
                        Text("\(String(format: "%.1f", medication.dosage!.amount)) \(String(describing: medication.dosage!.unit ?? "Unknown"))")
>>>>>>> 38c181ca62634a87272af1e1e34bbcf4f67c45b1
                            .font(.title3)
                            .foregroundColor(.black)
                        /*Text("\(String(format: "%.1f", medication.dosage!.amount)) \(medication.dosage.unit.rawValue)")
                         .font(.title3)
                         .foregroundColor(.black)*/
                    }
                    
                    Spacer()
                    /*Button(action: onDelete) {
                     Image(systemName: "trash")
                     .foregroundColor(.red)
                     }*/
                }
                .padding([.bottom, .horizontal])
            }
            .background(RoundedRectangle(cornerRadius: 12)
                        // .fill(medication.rgbColor)
                .fill(sampleColor.opacity(0.7))
                .shadow(color: sampleColor, radius: 0, x: 0, y: 0)) // Apply shadow here)
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
// let rgbSampleColor = RGBColor(color: sampleColor)

/*struct MedicationView_Previews: PreviewProvider {
 var onDelete: () -> Void  // Closure for handling delete action
 static var previews: some View {
 MedicationView(medication: dummyMed, onDelete: {
 // Implement your delete action or leave it empty for preview purposes
 print("Delete action triggered")
 })    }
 }*/
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

extension RGBColor {
    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}


extension AnyTransition {
    static var fadeOut: AnyTransition {
        .asymmetric(insertion: .identity, removal: .opacity)
    }
}


enum MedicationTimeCategory: String, CaseIterable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case night = "Night"
}

func categorizeMedicationByTime(_ medication: Medication) -> MedicationTimeCategory {
    guard let timeToTake = medication.timeToTake else { return .morning } // Assuming you have a timeToTake
    let hour = Calendar.current.component(.hour, from: timeToTake)
    
    switch hour {
    case 6..<11: return .morning
    case 11..<15: return .afternoon
    case 15..<21: return .evening
    default: return .night
    }
}

func symbolForCategory(_ category: MedicationTimeCategory) -> String {
    switch category {
    case .morning: return "sunrise.fill"
    case .afternoon: return "sun.max.fill"
    case .evening: return "sunset.fill"
    case .night: return "moon.stars.fill"
    }
}


// Define a custom view for "No medications to take"
struct NoMedicationsView: View {
    var body: some View {
        VStack {
            Image(systemName: "face.smiling")
                .font(.largeTitle)
                .foregroundColor(.green)
            Text("No medications to take")
                .bold()
                .foregroundColor(.secondary)
                .font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensures the view takes full width
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 10) // Adjust the horizontal padding to match MedicationView's padding
    }
}

struct SectionHeader: View {
    let category: MedicationTimeCategory
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Image(systemName: symbolForCategory(category))
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(category.color)
            Text(category.rawValue)
                .font(.title)
                .bold()
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(category.backgroundColor)
        .cornerRadius(10)
    }
}

extension MedicationTimeCategory {
    var color: Color {
        switch self {
        case .morning:
            return Color.yellow
        case .afternoon:
            return Color.orange
        case .evening:
            return Color.purple
        case .night:
            return Color.blue
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .morning:
            return Color.yellow.opacity(0.4)
        case .afternoon:
            return Color.orange.opacity(0.4)
        case .evening:
            return Color.purple.opacity(0.4)
        case .night:
            return Color.blue.opacity(0.4)
        }
    }
}
