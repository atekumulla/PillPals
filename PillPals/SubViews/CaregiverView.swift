//
//  CaregiverView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 2/11/24.
//

import Foundation
import SwiftUI

struct CaregiverView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CalendarView(medication: dummyMedications[0])) {
                    RoundedRectangleButton(label: "Calendar")
                }


                NavigationLink(destination: ExportMedicationInfoView()) {
                    RoundedRectangleButton(label: "Export Medication Info")
                }

                Spacer()
            }
            .navigationBarTitle("Caregiver", displayMode: .large)
        }
    }
}

struct RoundedRectangleButton: View {
    var label: String

    var body: some View {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 80)
                .foregroundColor(Color.gray.opacity(0.2)) // Adjust color as needed
                .overlay(
                    HStack {
                        Spacer()
                        Text(label)
                            .foregroundColor(.blue)
                            .font(.title)
                            .padding()
                        Spacer()
                    }
                )
                .padding()
        }
}

//struct AddMedicationView: View {
//    var body: some View {
//        Text("Add Medication View")
//    }
//}

struct ExportMedicationInfoView: View {
    var body: some View {
        Text("Export Medication Info View")
    }
}

#Preview {
    CaregiverView()
}
