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
        daysOfWeekToTake: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.sunday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 30), // 30 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.5, green: 0.7, blue: 1.0)),
        priority: .normal,
        period: .morning,
        active: true
    ),
    Medication(
        name: "Ibuprofen",
        type: .tablet,
        dosage: Dosage(amount: 200, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.tuesday, DayOfWeek.thursday, DayOfWeek.friday, DayOfWeek.sunday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 15), // 15 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 1.0, green: 0.5, blue: 0.5)),
        priority: .high,
        period: .evening,
        active: true
    ),
    Medication(
        name: "Paracetamol",
        type: .tablet,
        dosage: Dosage(amount: 500, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.sunday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 30), // 30 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.8, green: 0.2, blue: 0.2)),
        priority: .normal,
        period: .morning,
        active: false
    ),
    Medication(
        name: "Vitamin C",
        type: .tablet,
        dosage: Dosage(amount: 1000, unit: .milligrams),
        datesToTake: [],
        daysOfWeekToTake: [DayOfWeek.tuesday, DayOfWeek.thursday, DayOfWeek.sunday],
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 15), // 15 days from now
        timeToTake: Date(),
        color: RGBColor(color: Color(red: 0.2, green: 0.6, blue: 0.2)),
        priority: .high,
        period: .evening,
        active: true
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
        period: .daytime,
        active: false
    ),
    // Add more medications as needed
]

let dummyEmergencyContacts: [EmergencyContact] = [
    EmergencyContact(name: "John Doe", phoneNumber: "123-456-7890", relationship: "Friend"),
    EmergencyContact(name: "Jane Smith", phoneNumber: "987-654-3210", relationship: "Family Member"),
    EmergencyContact(name: "Bob Johnson", phoneNumber: "555-123-4567", relationship: "Neighbor"),
    // Add more dummy emergency contacts as needed
]
