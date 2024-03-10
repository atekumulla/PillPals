import Foundation
import SwiftUI

struct CalendarView: View {
    var medication: Medication
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<7) { index in
                let date = dateForDay(index: index)
                VStack {
                    Text("\(dayOfWeek(for: date))") // Display day of the week
                        .font(.caption)
                    Text("\(dayOfMonth(for: date))")
                        .frame(width: 30, height: 30)
                        .background(medication.datesToTake.contains(where: { $0.date == date }) ? Color.green : Color.clear)
                        .cornerRadius(15)
                }
            }
        }
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
}


