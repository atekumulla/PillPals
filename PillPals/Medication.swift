//
//  Medication.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//

import Foundation

struct Medication: Identifiable {
    var id = UUID() // This provides a unique identifier for each Medication
    var name: String
    var dosage: String
    var instructions: String
    var dueStatus: String
    var imageFileName: String
}

struct MedicationData {
    static let medications: [Medication] = [
        Medication(name: "Adderal", dosage: "15 mg", instructions: "Take with water", dueStatus: "Due Now", imageFileName: "pillpic"),
        Medication(name: "Cocaine", dosage: "25 mg", instructions: "Take after meals", dueStatus: "Due Next", imageFileName: "pillpic"),
        Medication(name: "Birth Control", dosage: "500 mg", instructions: "Take ON TIME", dueStatus: "Due Later", imageFileName: "pillpic"),
        Medication(name: "Other Med", dosage: "25 mg", instructions: "Take after meals", dueStatus: "Due Later", imageFileName: "pillpic")
        // Add more medications as needed
    ]
}

