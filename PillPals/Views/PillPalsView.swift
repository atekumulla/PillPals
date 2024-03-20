//
//  CaregiverPals.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 2/11/24.
//

import Foundation
import SwiftUI

let dummyEmergencyContacts: [EmergencyContact] = [
    EmergencyContact(name: "John Doe", phoneNumber: "123-456-7890", relationship: "Friend"),
    EmergencyContact(name: "Jane Smith", phoneNumber: "987-654-3210", relationship: "Family Member"),
    EmergencyContact(name: "Bob Johnson", phoneNumber: "555-123-4567", relationship: "Neighbor"),
    // Add more dummy emergency contacts as needed
]

struct PillPalsView: View {
    var emergencyContacts: [EmergencyContact]

    var body: some View {
        VStack {
            ForEach(emergencyContacts) { contact in
                EmergencyContactBoxView(contact: contact)
            }
        }
        .padding()
        .navigationBarTitle("PillPals", displayMode: .large)
    }
}

struct EmergencyContactBoxView: View {
    var contact: EmergencyContact

    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.name)
                .font(.title)
                .foregroundColor(.blue)

            Divider()

            HStack {
                Text("Phone Number:")
                Spacer()
                Text(contact.phoneNumber)
            }

            HStack {
                Text("Relationship:")
                Spacer()
                Text(contact.relationship)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    PillPalsView(emergencyContacts: dummyEmergencyContacts)
}

struct EmergencyContact: Identifiable {
    var id = UUID()
    var name: String
    var phoneNumber: String
    var relationship: String
}
