//
//  Medication.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//

import Foundation

//struct Medication: Identifiable {
//    var id = UUID() // This provides a unique identifier for each Medication
//    var name: String
//    var dosage: String
//    var instructions: String
//    var dueStatus: String
//    var imageFileName: String
//}

//struct MedicationData {
//    static let medications: [Medication] = [
//        Medication(name: "Adderal", dosage: "15 mg", instructions: "Take with water", dueStatus: "Due Now", imageFileName: "pillpic"),
//        Medication(name: "Cocaine", dosage: "25 mg", instructions: "Take after meals", dueStatus: "Due Next", imageFileName: "pillpic"),
//        Medication(name: "Birth Control", dosage: "500 mg", instructions: "Take ON TIME", dueStatus: "Due Later", imageFileName: "pillpic"),
//        Medication(name: "Other Med", dosage: "25 mg", instructions: "Take after meals", dueStatus: "Due Later", imageFileName: "pillpic")
//        // Add more medications as needed
//    ]
//}

/*
 
 struct Medication: Identifiable, Codable {
     
     var id = UUID() // Unique identifier for each medication
     var name: String
     var type: MedicationType
     var dosage: Dosage
     var datesToTake: [MedicationDateStatus] // Array of dates when the medication should be taken
     var daysOfWeekToTake: [DayOfWeek] // Array of days of the week
     var startDate: Date
     var endDate: Date
     var timeToTake: Date // Time to take the medication
     //var color: Color // Could be a string like "Red", "Blue", etc.
     var color: RGBColor
     var uiColor: Color {
         color.color
     }
     var priority: Priority = .normal // Default is normal
     var imageName: String = "pills" // Default SF Symbol for a pill
     var period: MedicationPeriod
     //var notificationIdentifiers: [String] = [] // Store notification identifiers

     func markMedicationAsTaken() {
         print("testintaken")
     }
 }
 */
