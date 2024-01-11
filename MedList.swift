//
//  MedList.swift
//  PillPals
//
//  Created by Tania Sapre on 12/3/23.
//

import SwiftUI

struct MedList: View {

    var body: some View {
        ScrollViewReader { scrollView in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        ForEach(dummyMedications) { medication in
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
                        .padding(.top, 90)
                    }
                    .id("top") // Set an identifier for the top to scroll to
                    .padding()
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
                                // Scroll to the top when tapped
                                withAnimation {
                                    scrollView.scrollTo("top")
                                }
                            }
                    )
                    .edgesIgnoringSafeArea(.top) // Ignore the safe area for the top edge
            }
        }
    }
}

struct MedList_Previews: PreviewProvider {
    static var previews: some View {
        MedList()
    }
}

