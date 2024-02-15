//
//  SelectedDaysView.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/12/23.
//

import Foundation
import SwiftUI

struct SelectedDaysView: View {
    var selectedDays: [DayOfWeek]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                ForEach(selectedDays, id: \.self) { day in
                    Text(day.title)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
    }
}
