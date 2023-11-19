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
}
