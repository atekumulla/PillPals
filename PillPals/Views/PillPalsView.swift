//
//  CaregiverPals.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 2/11/24.
//

import Foundation
import SwiftUI

class EmergencyContactsViewModel: ObservableObject {
    @Published var emergencyContacts: [EmergencyContact] = []

    init() {
        self.loadContacts()
    }

    func loadContacts() {
        if let savedContactsData = UserDefaults.standard.data(forKey: "EmergencyContacts"),
           let savedContacts = try? JSONDecoder().decode([EmergencyContact].self, from: savedContactsData) {
            self.emergencyContacts = savedContacts
        }
    }

    func saveContacts() {
        if let encodedData = try? JSONEncoder().encode(self.emergencyContacts) {
            UserDefaults.standard.set(encodedData, forKey: "EmergencyContacts")
        }
    }

    func addContact(_ contact: EmergencyContact) {
        self.emergencyContacts.append(contact)
        self.saveContacts()
    }

    func deleteContact(at indexSet: IndexSet) {
        self.emergencyContacts.remove(atOffsets: indexSet)
        self.saveContacts()
    }
}


struct PillPalsView: View {
    @ObservedObject var viewModel = EmergencyContactsViewModel()
    @State private var showingAddContactSheet = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.emergencyContacts.isEmpty {
                    DefaultContactView()
                } else {
                    List {
                        ForEach(viewModel.emergencyContacts.indices, id: \.self) { index in
                            EmergencyContactBoxView(contact: viewModel.emergencyContacts[index]) {
                                viewModel.deleteContact(at: IndexSet([index]))
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("PillPals", displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddContactSheet = true
                }) {
                    HStack {
                        Spacer()
                        Text("Add Contact")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            )
            .sheet(isPresented: $showingAddContactSheet) {
                AddEmergencyContactView(viewModel: viewModel, isPresented: $showingAddContactSheet)
            }
        }
    }
}

struct DefaultContactView: View {
    var body: some View {
        VStack {
            Text("No emergency contacts found.")
                .font(.headline)
                .padding()

            Text("Click \"Add Contact\" to create a new Emergency Contact")
                .multilineTextAlignment(.center)
        }
    }
}





struct EmergencyContactBoxView: View {
    var contact: EmergencyContact
    var onDelete: () -> Void // Closure to handle delete action
    @State private var showingConfirmationAlert = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(contact.name)
                    .font(.title)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Button(action: {
                    showingConfirmationAlert = true
                }) {
                    Image(systemName: "trash")
                    Text("Delete")
                }
                .foregroundColor(.red)
                .alert(isPresented: $showingConfirmationAlert) {
                    Alert(
                        title: Text("Are you sure?"),
                        message: Text("Are you sure you want to delete \(contact.name)'s contact?"),
                        primaryButton: .destructive(Text("Delete")) {
                            onDelete()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }

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



struct AddEmergencyContactView: View {
    @ObservedObject var viewModel: EmergencyContactsViewModel
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var relationship = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Relationship", text: $relationship)
                }

                Section {
                    Button("Add Contact") {
                        viewModel.addContact(EmergencyContact(name: name, phoneNumber: phoneNumber, relationship: relationship))
                        isPresented = false // Dismiss the sheet
                    }
                }
            }
            .navigationBarTitle("Add Emergency Contact")
            .navigationBarTitleDisplayMode(.inline) // Ensure entire title is displayed
        }
    }
}

struct PillPalsView_Previews: PreviewProvider {
    static var previews: some View {
        PillPalsView()
    }
}
