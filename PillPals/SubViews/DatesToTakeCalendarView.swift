//
//  DatesToTakeCalendarView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/27/24.
//

import Foundation
import SwiftUI


struct DatesToTakeCalendarView: View {
    @State private var currentDate = Date()
    var medication: Medication
    
    // Adjust based on your actual model
    enum DateStatus: String {
        case taken = "taken"
        case notTaken = "notTaken"
        case skipped = "skipped"
    }
    
    var body: some View {
        VStack {
            CalendarHeader(currentDate: $currentDate)
            DaysOfWeekHeader()
            DatesGridView(currentDate: $currentDate, medication: medication)
        }
    }
}

struct CalendarHeader: View {
    @Binding var currentDate: Date
    
    var body: some View {
        HStack {
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
            }) {
                Image(systemName: "chevron.left.circle")
                    .font(.system(size: 28)) // Enlarge chevron
            }
            .padding(5)
            
            Spacer()
            
            Text(currentMonth)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
            }) {
                Image(systemName: "chevron.right.circle")
                    .font(.system(size: 28)) // Enlarge chevron
            }
            .padding(5)
        }
        .padding()
    }
    
    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }
}

struct DaysOfWeekHeader: View {
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}


struct DatesGridView: View {
    @Binding var currentDate: Date
    var medication: Medication
    
    private var daysOffset: Int {
        let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
        // Adjust based on the first day of week in your calendar
        // For example, if your calendar week starts on Sunday, and `weekday` is 1 (Sunday), then offset is 0.
        return weekday - 1 // Adjust this calculation as needed
    }
    
    private var firstDayOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
    }
    
    private var daysInMonth: [Date] {
        guard let monthInterval = Calendar.current.dateInterval(of: .month, for: currentDate) else { return [] }
        return Calendar.current.generateDates(inside: monthInterval, matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            // Offset for empty days at the start of the month
            ForEach(0..<daysOffset, id: \.self) { _ in
                Text("")
            }
            ForEach(daysInMonth, id: \.self) { date in
                DayView(date: date, medication: medication)
            }
        }
    }
}



struct DayView: View {
    var date: Date
    var medication: Medication
    
    var body: some View {
        Text("\(date, formatter: dayFormatter)")
            .frame(width: 45, height: 45, alignment: .center) // Adjusted for visibility and consistency
            .background(circleBackground) // Conditional background
            .foregroundColor(shouldHighlightDate ? .white : .primary) // Ensures text is visible against all backgrounds
            .font(.title2) // Keeps the text size consistent
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    // Compute the background view based on whether the date is to be highlighted
    private var circleBackground: some View {
        Group {
            if shouldHighlightDate {
                Circle()
                    .fill(Color.blue)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 0.5)) // Adds a subtle gray border for visibility
            } else {
                Circle()
                    .fill(Color.clear) // No fill for days not highlighted
            }
        }
        .frame(width: 40, height: 40) // Ensure circle size is consistent
    }
    
    // Determine if this date should be highlighted based on the medication schedule
    private var shouldHighlightDate: Bool {
        // For simplicity, this assumes medication.dateStatusArray contains Date objects.
        // Adjust this logic according to your actual data structure.
        let calendar = Calendar.current
        return medication.dateStatusArray.contains(where: { status in
            calendar.isDate(status.date!, inSameDayAs: date)
        })
    }
    
    /*private var isMedicationDate: Bool {
            let calendar = Calendar.current
            // Assuming medication.dateStatusArray is a list of dates when medication needs to be taken.
            let isTaken = medication.dateStatusArray.contains(where: { status in
                calendar.isDate(status.date!, inSameDayAs: date) && status.taken
            })
            
            let isScheduled = medication.dateStatusArray.contains(where: { status in
                calendar.isDate(status.date!, inSameDayAs: date)
            })

            return isScheduled && isTaken
        }*/
}



extension Calendar {
    func generateDates(inside interval: DateInterval, matching components: DateComponents) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(startingAfter: interval.start, matching: components, matchingPolicy: .nextTime) { date, _, stop in
            guard let date = date else { return }
            if date < interval.end {
                dates.append(date)
            } else {
                stop = true
            }
        }

        return dates
    }
}



