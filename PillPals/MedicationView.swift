//
//  MedicationView.swift
//  PillPals
//
//  Created by anush on 11/19/23.
//
import SwiftUI

struct MedicationView: View {
    var medications: [Medication]

    var body: some View {
        VStack {
            ForEach(medications) { medication in
                MedicationBoxView(
                    medicationName: medication.name,
                    dosage: medication.dosage,
                    instructions: medication.instructions,
                    nextDue: medication.dueStatus,
                    imageFileName: medication.imageFileName
                )
            }
        }
        .padding()
    }
}


struct MedicationBoxView: View {
    var medicationName: String
    var dosage: String
    var instructions: String
    var nextDue: String
    var imageFileName: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(medicationName)
                    .font(.title)
                    .foregroundColor(.blue)
                
                Spacer()
                
                // Display the image of the medication
                Image(imageFileName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50) // Adjust the size as needed
                    .cornerRadius(10)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }

            Divider()

            HStack {
                Text("Instructions:")
                Spacer()
                Text(instructions)
            }
            
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    MedicationView(medications: MedicationData.medications)
}


