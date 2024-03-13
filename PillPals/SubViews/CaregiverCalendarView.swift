//
//  CaregiverCalendarView.swift
//  PillPals
//
//  Created by Tania Sapre on 3/13/24.
//

import SwiftUI

struct CaregiverCalendarView: View {
    var medication: Medication
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil // Initialize with the current date
    @State private var buttonPressed: Bool = false
    
    var body: some View {
        VStack {
            // Calendar header
            Text("Calendar")
                .font(.title)
                .padding(.top, 20)
            
            // Calendar view
            LazyVGrid(columns: columns) {
                ForEach(0..<7) { index in
                    let date = dateForDay(index: index)
                    let dayWeek: String = dayOfWeek(for: date)
                    let currentDate_week: String = dayOfWeek(for: currentDate)
                    
                    VStack { // Use VStack to stack day of week and day of month vertically
                        Text("\(dayOfWeek(for: date))") // Display day of the week horizontally
                            .font(.callout)
                        Button(action: {
                            selectedDate = date // Set the selected date when clicked
                            buttonPressed = true
                        }) {
                            Text("\(dayOfMonth(for: date))")
                                .frame(width: 30, height: 30)
                                .background(
                                    // Highlight light blue if the date is selected
                                    (selectedDate == date && buttonPressed) || (!buttonPressed && dayWeek == currentDate_week) ? Color.blue.opacity(0.3) : Color.clear
                                )
                                .cornerRadius(15)
                        }
                    }
                }
                Text("Medication Info: ")
                    .font(.headline)
                    .padding(.top, 40)
                    .frame(width: 500, height: 30)
                    .position(x: 200)
            }
        }.padding(.bottom, 600)
    }
    
    private func dateForDay(index: Int) -> Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        return calendar.date(byAdding: .day, value: index, to: startOfWeek)!
    }
    
    private func dayOfWeek(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Day of the week abbreviated
        return formatter.string(from: date)
    }
    
    private func dayOfMonth(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Day of the month
        return formatter.string(from: date)
    }
    private func DisplayInfoFuture(for date: Date) -> String {
        return ""
    }
}
