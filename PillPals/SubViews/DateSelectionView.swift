import SwiftUI
import Foundation


/// This code handles the view where the user can select Days Of The Week
struct DaySelectionView: View {
    @Binding var selectedDays: [DayOfWeek] // Binding to the selection in the parent view
    @Environment(\.presentationMode) var presentationMode
    
    
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

///  Button which represents the actual Day as a circle. handles the color by changing depending on tap
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

