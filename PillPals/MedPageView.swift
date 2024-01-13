//
//  MedPageView.swift
//  PillPals
//
//  Created by anush on 1/12/24.
//

import SwiftUI

struct MedPageView: View {
    var medications: [Medication]

    private var medicationsByActiveStatus: [Bool: [Medication]] {
        let activeMedications = medications.filter { $0.active }
        let inactiveMedications = medications.filter { !$0.active }

        return [true: activeMedications, false: inactiveMedications]
    }

    var body: some View {
        VStack {
            Text("Medications")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            ScrollView {
                // Display medications for each active status
                ForEach([true, false], id: \.self) { isActive in
                    if let medicationsForStatus = medicationsByActiveStatus[isActive] {
                        Section(header: HStack {
                            Text(isActive ? "Active Medications" : "Inactive Medications")
                                .font(.title)
                                .foregroundColor(isActive ? .green : .red) // Use different colors
                            Spacer()
                        }
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))) {
                                ForEach(medicationsForStatus) { medication in
                                    MedicationBoxView(
                                        medication: medication
                                    )
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle("Medications", displayMode: .large)
    }
}

#Preview {
    MedPageView(medications: dummyMedications)
}
