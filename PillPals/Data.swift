//
//  Data.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/10/23.
//

import Foundation
import SwiftUI

enum MedicationType: String, CaseIterable, Codable {
    case pill, tablet, capsule, liquid
}

enum Priority: String, CaseIterable, Codable {
    case normal, high
}

enum MedicationPeriod: String, CaseIterable, Hashable, Codable {
    case morning = "sunrise"
    case daytime = "sun.max"
    case evening = "sunset"
    case night = "moon"
}

struct Dosage: Codable {
    var amount: Double // The numeric amount of the dosage
    var unit: Unit // The unit of measurement for the dosage

    enum Unit: String, CaseIterable, Codable {
        case milligrams = "mg"
        case grams = "g"
        case milliliters = "mL"
        case count = "count" // Default unit when specific measurement is not required
    }
}

enum DayOfWeek: String, CaseIterable, Identifiable, Codable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

    var id: String { self.rawValue }
    var title: String { self.rawValue.capitalized }

    var shortTitle: String {
        switch self {
        case .sunday: return "Su"
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "Th"
        case .friday: return "F"
        case .saturday: return "Sa"
        }
    }
    
    var calendarValue: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
    
}

struct MedicationDateStatus: Codable {
    var date: Date
    var taken: Bool
}

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

struct UserInfo: Identifiable, Codable {
    var id = UUID()
    var name: String = "User"
    var age: Int
}


struct RGBColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double = 1.0

    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }

    init(color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.alpha = Double(alpha)
    }
}



