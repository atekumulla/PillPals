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
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        ScrollView {
            NavigationLink(destination: CaregiverCalendarView().environment(\.managedObjectContext, self.moc)) {
                RoundedRectangleButton(label: "Calendar")
            }
            
            NavigationLink(destination: ExportMedicationInfoView().environment(\.managedObjectContext, self.moc)) {
                RoundedRectangleButton(label: "Export Medication Info")
            }
            
            Button(action: {
                showingAddMedicationView = true
            }) {
                RoundedRectangleButton(label: "Add New Medication")
            }
            .sheet(isPresented: $showingAddMedicationView) {
                AddMedicationView().environment(\.managedObjectContext, self.moc)
            }
            
            Spacer()
        }
        .navigationBarTitle("Caregiver")
    }
}

struct RoundedRectangleButton: View {
    var label: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 80)
            .foregroundColor(Color.gray.opacity(0.2))
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
