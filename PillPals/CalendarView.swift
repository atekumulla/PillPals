//
//  CalendarView.swift
//  PillPals
//
//  Created by anush on 1/14/24.
//
import SwiftUI

struct CalendarView: View {
    let currentDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(currentDate, formatter: DateFormatter.monthAndYearFormatter)
                    .font(.title)
                    .padding()

                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                    ForEach(DayOfWeek.allCases, id: \.self) { day in
                        Text(day.shortTitle)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                            .padding(8)
                    }

                    ForEach(monthRange(), id: \.self) { day in
                        Button(action: {
                            // Handle date click action here
                            print("Clicked on day \(day.day)")
                        }) {
                            Text(day.isCurrentMonth ? "\(day.day)" : "")
                                .font(.headline)
                                .frame(width: 30, height: 30)
                                .padding(8)
                                .background(day.isCurrentMonth ? (day.day == Calendar.current.component(.day, from: currentDate) ? Color.cyan : Color.white) : Color.gray.opacity(0.3))
                                .clipShape(Rectangle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .foregroundColor(day.isCurrentMonth ? .black : .gray)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Calendar", displayMode: .large)
        }
    }

    // Function to generate an array of DateInfo structs for the current month
    func monthRange() -> [DateInfo] {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)

        // Get the first day of the month and the range of days
        let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!

        var dates: [DateInfo] = []

        // Add blank placeholders for days before the first day of the month
        for _ in 1..<calendar.component(.weekday, from: firstDayOfMonth) {
            dates.append(DateInfo(day: 0, isCurrentMonth: false))
        }

        // Add days of the month
        for day in range.lowerBound..<range.upperBound {
            let date = calendar.date(from: DateComponents(year: year, month: month, day: day))!
            let isCurrentMonth = calendar.isDate(date, equalTo: currentDate, toGranularity: .month)
            dates.append(DateInfo(day: day, isCurrentMonth: isCurrentMonth))
        }

        return dates
    }
}

extension DateFormatter {
    static let monthAndYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

struct DateInfo: Hashable {
    let day: Int
    let isCurrentMonth: Bool
}

#Preview {
    CalendarView()
}
