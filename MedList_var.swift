//
//  MedList_var.swift
//  PillPals
//
//  Created by Tania Sapre on 12/3/23.
//

import Foundation
import SwiftUI
struct Medication: Identifiable {

var id = UUID() // Unique identifier for each medication
var name: String
var color: String // Could be a string like "Red", "Blue", etc.

var imageName: String = "pills" // Default SF Symbol for a pill
}
