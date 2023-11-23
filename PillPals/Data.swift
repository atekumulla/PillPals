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

enum MedicationPeriod: String, CaseIterable, Hashable {
    case morning = "sunrise"
    case daytime = "sun.max"
    case evening = "sunset"
    case night = "moon"
}

struct Dosage {
    var amount: Double // The numeric amount of the dosage
    var unit: Unit // The unit of measurement for the dosage

    enum Unit: String, CaseIterable {
        case milligrams = "mg"
        case grams = "g"
        case milliliters = "mL"
        case count = "count" // Default unit when specific measurement is not required
    }
}

struct MedicationDateStatus {
    var date: Date
    var taken: Bool
}

struct Medication: Identifiable {
    var id = UUID() // Unique identifier for each medication
    var name: String
    var type: MedicationType
    var dosage: Dosage
    var datesToTake: [MedicationDateStatus] // Array of dates when the medication should be taken
    var daysOfWeekToTake: [DayOfWeek] // Array of days of the week
    var startDate: Date
    var endDate: Date
    var timeToTake: Date // Time to take the medication
    var color: Color // Could be a string like "Red", "Blue", etc.
    var priority: Priority = .normal // Default is normal
    var imageName: String = "pills" // Default SF Symbol for a pill
    var period: MedicationPeriod
}

struct User: Identifiable {
    var id = UUID()
    var name: String = "User"
    var age: Int
}
