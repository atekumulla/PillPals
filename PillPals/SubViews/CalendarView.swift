import Foundation
import SwiftUI

struct CalendarView: View {
    var medication: Medication
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil // Track the selected date
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<7) { index in
                let date = dateForDay(index: index)
                
                VStack { // Use VStack to stack day of week and day of month vertically
                    Text("\(dayOfWeek(for: date))") // Display day of the week horizontally
                        .font(.caption)
                    Button(action: {
                        selectedDate = date // Set the selected date when clicked
                    }) {
                        Text("\(dayOfMonth(for: date))")
                            .frame(width: 30, height: 30)
                            .background(
                                // Highlight light blue if the date is selected
                                selectedDate == date ? Color.blue.opacity(0.3) : Color.clear
                            )
                            .cornerRadius(15)
                    }
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
struct CaregiverCalendarView: View {
    var medication: Medication
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil // Track the selected date
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<7) { index in
                let date = dateForDay(index: index)
                
                VStack { // Use VStack to stack day of week and day of month vertically
                    Text("\(dayOfWeek(for: date))") // Display day of the week horizontally
                        .font(.caption)
                    Button(action: {
                        selectedDate = date // Set the selected date when clicked
                    }) {
                        Text("\(dayOfMonth(for: date))")
                            .frame(width: 30, height: 30)
                            .background(
                                // Highlight light blue if the date is selected
                                selectedDate == date ? Color.blue.opacity(0.3) : Color.clear
                            )
                            .cornerRadius(15)
                    }
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
    


