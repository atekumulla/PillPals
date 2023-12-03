//
//  MedList.swift
//  PillPals
//
//  Created by Tania Sapre on 11/29/23.
//

import SwiftUI

struct MedList: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("View All Medications")
                    .font(.title)

                VStack(spacing: 10) {
                    ForEach(0..<20) { _ in
                        Rectangle()
                            .frame(width: 350, height: 100)
                            .cornerRadius(10)
                            .foregroundColor(.blue)
                            .overlay(
                                Text("Hi")
                                    .foregroundColor(.white)
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
