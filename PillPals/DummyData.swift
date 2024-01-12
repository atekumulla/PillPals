//
//  DummyData.swift
//  PillPals
//
//  Created by anush on 1/11/24.
//

import Foundation
import SwiftUI

let dummyMedications: [Medication] = [
    Medication(
        name: "Aspirin",
        type: .tablet,
        dosage: Dosage(amount: 500, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.friday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 30), // 30 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.5, green: 0.7, blue: 1.0)),
        priority: .normal,
        period: .morning
    ),
    Medication(
        name: "Ibuprofen",
        type: .tablet,
        dosage: Dosage(amount: 200, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.tuesday, DayOfWeek.thursday, DayOfWeek.saturday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 15), // 15 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 1.0, green: 0.5, blue: 0.5)),
        priority: .high,
        period: .evening
    ),
    Medication(
        name: "Paracetamol",
        type: .tablet,
        dosage: Dosage(amount: 500, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.friday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 30), // 30 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.8, green: 0.2, blue: 0.2)),
        priority: .normal,
        period: .morning
    ),
    Medication(
        name: "Vitamin C",
        type: .tablet,
        dosage: Dosage(amount: 1000, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.tuesday, DayOfWeek.thursday, DayOfWeek.saturday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 15), // 15 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.2, green: 0.6, blue: 0.2)),
        priority: .high,
        period: .evening
    ),
    Medication(
        name: "Omega-3",
        type: .capsule,
        dosage: Dosage(amount: 1, unit: .grams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.friday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 45), // 45 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.2, green: 0.2, blue: 0.8)),
        priority: .normal,
        period: .daytime
    ),
    // Add more medications as needed
]
