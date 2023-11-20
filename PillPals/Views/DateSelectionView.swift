import SwiftUI
import Foundation

enum DayOfWeek: String, CaseIterable, Identifiable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

    var id: String { self.rawValue }
    var title: String { self.rawValue.capitalized }

    var shortTitle: String {
        switch self {
        case .sunday: return "Su"
        case .monday: return "M"
        case .tuesday: return "T"
        case .wednesday: return "W"
        case .thursday: return "Th"
        case .friday: return "F"
        case .saturday: return "Sa"
        }
    }
    
    var calendarValue: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
    
}

struct DaySelectionView: View {
    @Binding var selectedDays: [DayOfWeek] // Binding to the selection in the parent view
    @Environment(\.presentationMode) var presentationMode

    // ... other states and methods ...

    var body: some View {
        VStack {
            HStack {
                ForEach(DayOfWeek.allCases, id: \.self) { day in
                    CircleButton(day: day, isSelected: selectedDays.contains(day)) {
                        if let index = selectedDays.firstIndex(of: day) {
                            selectedDays.remove(at: index)
                        } else {
                            selectedDays.append(day)
                        }
                    }
                }
            }
            Button("Save") {
                // Handle save action
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CircleButton: View {
    var day: DayOfWeek
    var isSelected: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(day.shortTitle)
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected ? .white : .black) // Text color changes based on selection
                .background(isSelected ? .blue : .gray)
                .clipShape(Circle())
        }
    }
}
