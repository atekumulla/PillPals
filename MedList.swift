//
//  MedList.swift
//  PillPals
//
//  Created by Tania Sapre on 12/3/23.
//

import SwiftUI

struct MedList: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("View All Medications")
                    .font(.title)
                    .bold()

                VStack(spacing: 10) {
                    ForEach(0..<10) { _ in
                        Rectangle()
                            .frame(width: 350, height: 100)
                            .cornerRadius(10)
                            .foregroundColor(Color(red: 204/255, green: 229/255, blue: 255/255))
                            .overlay(
                                Text("Razadyne")
                                    .foregroundColor(.black)
                                    .font(.title2)
                                    .bold()
                                    .frame(maxWidth: .infinity, alignment: .leading) // Set left alignment
                                    .padding() //make it not too left aligned
                            )
                    }
                }

            }
            .padding() // Add padding to provide some space around the content
        }
    }
}

struct MedList_Previews: PreviewProvider {
    static var previews: some View {
        MedList()
    }
}
