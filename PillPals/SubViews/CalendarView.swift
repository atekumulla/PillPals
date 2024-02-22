//
//  CalendarView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/20/23.
//

import Foundation
import SwiftUI

/// Creates a static Calendar view which dont works



struct CalendarHelper {
    static func datesInMonth(date: Date, using calendar: Calendar = Calendar.current) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        return range.compactMap { day -> Date? in
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = day
            return calendar.date(from: components)
        }
    }
}



struct CalendarView: View {
    var medication: Medication
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(CalendarHelper.datesInMonth(date: currentDate), id: \.self) { date in
                Text("\(date, formatter: dateFormatter)")
                    .frame(width: 30, height: 30)
                    .background(medication.datesToTake.contains(where: { $0.date == date }) ? Color.green : Color.clear)
                    .cornerRadius(15)
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
}

//boop
