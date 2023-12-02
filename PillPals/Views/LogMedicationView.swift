//
//  LogMedicationView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/30/23.
//

import Foundation
import SwiftUI

struct LogView: View {
    var medication: Medication
    @Binding var isPresented: Bool

    var body: some View {
        // Layout for logging the medication intake
        VStack {
            Text("Did you take your \(medication.name)?")
            // Add buttons or other UI elements for logging
            // medication.markMedicationAsTaken()
        }
    }
}

