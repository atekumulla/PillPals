//
//  MedList.swift
//  PillPals
//
//  Created by Tania Sapre on 12/3/23.
//

// MedList.swift
import SwiftUI

struct MedList: View {
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollView in
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack {
                            // Active Medications
                            VStack {
                                Text("Active Medications")
                                    .font(.title)
                                    .padding(.top, 20)
                                    .bold()

                                ForEach(dummyMedications.filter { $0.Active }.sorted(by: { $0.Brand_name < $1.Brand_name })) { medication in
                                    NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                        Rectangle()
                                            .frame(width: 350, height: 100)
                                            .cornerRadius(10)
                                            .foregroundColor(Color(red: 204/255, green: 229/255, blue: 255/255))
                                            .overlay(
                                                Text(medication.Brand_name)
                                                    .foregroundColor(.black)
                                                    .font(.title2)
                                                    .bold()
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding()
                                            )
                                    }
                                }
                                .padding(.top, 10)
                            }

                            // Inactive Medications
                            VStack {
                                Text("Inactive Medications")
                                    .font(.title)
                                    .padding(.top, 20)
                                    .bold()

                                ForEach(dummyMedications.filter { !$0.Active }.sorted(by: { $0.Brand_name < $1.Brand_name })) { medication in
                                    NavigationLink(destination: MedicationDetailView(medication: medication)) {
                                        Rectangle()
                                            .frame(width: 350, height: 100)
                                            .cornerRadius(10)
                                            .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
                                            .overlay(
                                                Text(medication.Brand_name)
                                                    .foregroundColor(.black)
                                                    .font(.title2)
                                                    .bold()
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding()
                                            )
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }

                    // Fixed bar at the top
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 130)
                        .overlay(
                            Text("View All Medications")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                                .onTapGesture {
                                    // Scroll to the top of the active medications when tapped
                                    withAnimation {
                                        scrollView.scrollTo("topActive")
                                    }
                                }
                        )
                        .edgesIgnoringSafeArea(.top) // Ignore the safe area for the top edge
                }
            }
            .navigationTitle("Medications")
        }
    }
}

struct MedList_Previews: PreviewProvider {
    static var previews: some View {
        MedList()
    }
}

