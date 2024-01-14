//
//  PillPalsView.swift
//  PillPals
//
//  Created by anush on 1/13/24.
//

import SwiftUI

struct PillPalsView: View {
    var emergencyContacts: [EmergencyContact]

    var body: some View {
        VStack {
            ForEach(emergencyContacts) { contact in
                EmergencyContactBoxView(contact: contact)
            }
        }
        .padding()
        .navigationBarTitle("PillPals", displayMode: .inline)
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
