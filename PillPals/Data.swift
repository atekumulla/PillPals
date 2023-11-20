//
//  Data.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/10/23.
//

import Foundation
import SwiftUI

enum MedicationType: String, CaseIterable {
    case pill, tablet, capsule, liquid
}

enum Priority: String, CaseIterable {
    case normal, high
}

struct Medication: Identifiable {
    var id = UUID() // Unique identifier for each medication
    var name: String
    var type: MedicationType
    var datesToTake: [Date] // Array of dates when the medication should be taken
    var daysOfWeekToTake: [DayOfWeek] // Array of days of the week
    var startDate: Date
    var endDate: Date
    var timeToTake: Date // Time to take the medication
    var color: Color // Could be a string like "Red", "Blue", etc.
    var priority: Priority = .normal // Default is normal
    var imageName: String = "pills" // Default SF Symbol for a pill
}
