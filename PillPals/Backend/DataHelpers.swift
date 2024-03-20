//
//  DataHelpers.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/13/24.
//

import Foundation

enum MedicationPeriod: String, CaseIterable, Hashable, Codable {
    case morning = "sunrise"
    case daytime = "sun.max"
    case evening = "sunset"
    case night = "moon"
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

enum MedicationType: String, CaseIterable, Codable {
    case pill, tablet, capsule, liquid
}

enum Priority: String, CaseIterable, Codable {
    case normal, high
}

enum DoseStatus: Codable {
    case taken
    case notTaken
    case takenLater(time: Date)
    
    // Custom encoding to handle the associated value
    enum CodingKeys: CodingKey {
        case base, time
    }
    
    enum Base: String, Codable {
        case taken, notTaken, takenLater
    }
    
    // Custom encoding and decoding to handle the associated value of `takenLater`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        
        switch base {
        case .taken:
            self = .taken
        case .notTaken:
            self = .notTaken
        case .takenLater:
            let time = try container.decode(Date.self, forKey: .time)
            self = .takenLater(time: time)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .taken:
            try container.encode(Base.taken, forKey: .base)
        case .notTaken:
            try container.encode(Base.notTaken, forKey: .base)
        case .takenLater(let time):
            try container.encode(Base.takenLater, forKey: .base)
            try container.encode(time, forKey: .time)
        }
    }
}


enum DosageUnit: String, CaseIterable, Codable {
    case milligram = "mg"
    case gram = "g"
    case milliliter = "ml"
    case unit = "unit"
}


/*struct DaysOfWeek: OptionSet {
    let rawValue: Int

    static let sunday = DaysOfWeek(rawValue: 1 << 0)
    static let monday = DaysOfWeek(rawValue: 1 << 1)
    static let tuesday = DaysOfWeek(rawValue: 1 << 2)
    static let wednesday = DaysOfWeek(rawValue: 1 << 3)
    static let thursday = DaysOfWeek(rawValue: 1 << 4)
    static let friday = DaysOfWeek(rawValue: 1 << 5)
    static let saturday = DaysOfWeek(rawValue: 1 << 6)

    // This will allow you to convert an array of `DayOfWeek` to a bitmask.
    static func from(_ days: [DayOfWeek]) -> DaysOfWeek {
        var daysOfWeek = DaysOfWeek([])
        days.forEach { day in
            switch day {
            case .sunday: daysOfWeek.insert(.sunday)
            case .monday: daysOfWeek.insert(.monday)
            // Add cases for the rest of the days...
            default: break
            }
        }
        return daysOfWeek
    }
}*/

struct DateIterator: Sequence, IteratorProtocol {
    var current: Date
    let end: Date
    let calendar: Calendar

    init(start: Date, end: Date, calendar: Calendar = .current) {
        self.current = start
        self.end = end
        self.calendar = calendar
    }

    mutating func next() -> Date? {
        if current > end { return nil }
        let nextDate = calendar.date(byAdding: .day, value: 1, to: current)!
        current = nextDate
        return current
    }
}
