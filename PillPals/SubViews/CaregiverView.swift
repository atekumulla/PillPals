//
//  CaregiverView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 2/11/24.
//

import Foundation
import SwiftUI

struct CaregiverView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddMedicationView = false
<<<<<<< HEAD
    @Environment(\.managedObjectContext) var moc

=======
    
>>>>>>> 38c181ca62634a87272af1e1e34bbcf4f67c45b1
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CaregiverCalendarView()) {
                    RoundedRectangleButton(label: "Calendar")
                }
                .environment(\.managedObjectContext, self.moc)
                
                
                NavigationLink(destination: ExportMedicationInfoView()) {
                    RoundedRectangleButton(label: "Export Medication Info")
                }
                
<<<<<<< HEAD
=======
//                NavigationLink(destination: AddMedicationView()()) {
//                    RoundedRectangleButton(label: "Add New Medication")
//                }
                
                Button(action: {
                    showingAddMedicationView = true
                }) {
                    RoundedRectangleButton(label: "Add New Medication")
                }
>>>>>>> 38c181ca62634a87272af1e1e34bbcf4f67c45b1

                
                //                NavigationLink(destination: AddMedicationView()()) {
                //                    RoundedRectangleButton(label: "Add New Medication")
                //                }
                
                Button(action: {
                    showingAddMedicationView = true
                }) {
                    RoundedRectangleButton(label: "Add New Medication")
                }
                
                Spacer()
            }
            .navigationBarTitle("Caregiver", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Exit") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddMedicationView) {
            AddMedicationView()
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

//struct ExportMedicationInfoView: View {
//    var body: some View {
//        Text("Export Medication Info View")
//    }
//}

#Preview {
    CaregiverView()
}
