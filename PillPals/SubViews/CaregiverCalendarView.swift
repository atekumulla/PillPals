import SwiftUI
import CoreData

struct CaregiverCalendarView: View {
    @Environment(\.managedObjectContext) var moc
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var buttonPressed: Bool = false
    @State private var medicationsForWeek: [Medication] = []
    @State private var isDetailsExpanded: Bool = false
    
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Calendar")
                    .font(.title)
                    .padding(.top, 20)
                
                // Your LazyVGrid for the calendar here
                LazyVGrid(columns: columns) {
                    ForEach(0..<7, id: \.self) { index in
                        let date = self.dateForDay(index: index)
                        VStack {
                            Text(self.dayOfWeek(for: date))
                                .font(.callout)
                            Button(action: {
                                self.selectedDate = date
                                self.buttonPressed = true
                                self.fetchMedicationsForSelectedDate()
                            }) {
                                Text(self.dayOfMonth(for: date))
                                    .frame(width: 30, height: 30)
                                    .background(self.isSelectedDate(date: date) ? Color.blue.opacity(0.3) : Color.clear)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
                
                
                // Your ForEach for Medication Info here
                // Medication Info section
                VStack(alignment: .leading) {
                    Text("Medication Info: ")
                        .font(.headline)
                        .padding(.top, 20)
                    
                    // Dynamic medication information based on selected date or current date
                    ForEach(self.medicationsForSelectedDate(), id: \.self) { medication in
                        Text("\(medication.name!) - \(self.medicationTimeString(medication: medication))")
                            .font(.subheadline)
                    }
                }
                
                // DisclosureGroup for medication details
                ForEach(medicationsForSelectedDate(), id: \.self) { medication in
                    DisclosureGroup(isExpanded: $isDetailsExpanded) {
                        VStack(alignment: .leading) {
                            MedicationDetailsView(medication: medication)
                            DosingScheduleView(medication: medication)
                        }
                    } label: {
                        Text(medication.name ?? "Medication")
                            .font(.headline)
                    }
                    .accentColor(.primary)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
        .onAppear {
            self.fetchMedicationsForWeek()
        }
    }
    
    
    
    private func dateForDay(index: Int) -> Date {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        return calendar.date(byAdding: .day, value: index, to: startOfWeek)!
    }
    
    private func dayOfWeek(for date: Date) -> String {
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    private func dayOfMonth(for date: Date) -> String {
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    private func isSelectedDate(date: Date) -> Bool {
        guard let selectedDate = selectedDate else { return false }
        return Calendar.current.isDate(selectedDate, inSameDayAs: date)
    }
    
    private func fetchMedicationsForWeek() {
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Medication.timeToTake, ascending: true)]
        request.predicate = NSPredicate(format: "startDate <= %@ AND endDate >= %@", startOfWeek as NSDate, endOfWeek as NSDate)
        
        do {
            medicationsForWeek = try moc.fetch(request)
        } catch {
            print("Error fetching medications: \(error)")
        }
    }
    
    private func fetchMedicationsForSelectedDate() {
        guard let selectedDate = selectedDate else { return }
        
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Medication.timeToTake, ascending: true)]
        request.predicate = NSPredicate(format: "startDate <= %@ AND endDate >= %@ AND daysOfWeek CONTAINS[c] %@", selectedDate as NSDate, selectedDate as NSDate, "\(Calendar.current.component(.weekday, from: selectedDate))")
        
        do {
            medicationsForWeek = try moc.fetch(request)
        } catch {
            print("Error fetching medications for selected date: \(error)")
        }
    }
    
    private func medicationsForSelectedDate() -> [Medication] {
        guard let selectedDate = selectedDate, buttonPressed else {
            return medicationsForWeek
        }
        
        return medicationsForWeek.filter { medication in
            guard let daysOfWeek = medication.daysOfWeek else { return false }
            let daysArray = daysOfWeek.components(separatedBy: ",")
            let dayNumber = Calendar.current.component(.weekday, from: selectedDate)
            return daysArray.contains("\(dayNumber)")
        }
    }
    
    private func medicationTimeString(medication: Medication) -> String {
        guard let timeToTake = medication.timeToTake else { return "N/A" }
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: timeToTake)
    }
}

// Assuming Medication conforms to Hashable
/*extension Medication: Hashable {
 public func hash(into hasher: inout Hasher) {
 if let id = self.id {
 hasher.combine(id)
 }
 }
 }*/


struct CalendarForCaregiverView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7) // 7 days in a week
    @Binding var currentDate: Date
    @Binding var selectedDate: Date?
    let onDateSelected: (Date) -> Void // Closure to call when a date is selected
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<7, id: \.self) { index in
                let date = self.dateForDay(index: index)
                
                VStack {
                    Text(self.dayOfWeek(for: date))
                        .font(.caption)
                    Button(action: {
                        self.selectedDate = date
                        self.onDateSelected(date)
                    }) {
                        Text(self.dayOfMonth(for: date))
                            .frame(width: 30, height: 30)
                            .background(self.selectedDate == date ? Color.blue.opacity(0.3) : Color.clear)
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
