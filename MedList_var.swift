//
//  MedList_var.swift
//  PillPals
//
//  Created by Tania Sapre on 12/3/23.
//
import Foundation
import SwiftUI
struct Medication: Identifiable {
<<<<<<< HEAD

=======
>>>>>>> f2d226fa700046c06f31eba40b9817dc82086f73
    var id = UUID() // Unique identifier for each medication
    var Brand_name: String
    var Status_color: Color // Could be a string like "Red", "Blue", etc.
    var priority_color: Color
    var dosage: Double
    var image: UIImage
    var Active: Bool
}
<<<<<<< HEAD


 

=======
 
>>>>>>> f2d226fa700046c06f31eba40b9817dc82086f73
var dummyMedications: [Medication] = [
    Medication(
        Brand_name: "Aspirin",
        Status_color: .red,
        priority_color: .red,
        dosage: 12.1,
        image: UIImage(named: "Aspirin_image")!,
        Active: true
    ),
    Medication(
        Brand_name: "Ibuprofen",
        Status_color: .blue,
        priority_color: .red,
        dosage: 12.1,
        image: UIImage(named: "Ibuprofen_image")!,
        Active: false
    ),
    // ... more dummy medications
]
<<<<<<< HEAD
=======

>>>>>>> f2d226fa700046c06f31eba40b9817dc82086f73
