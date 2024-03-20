import SwiftUI
import CoreData

struct LogMedicationSheet: View {
    @Environment(\.managedObjectContext) private var moc
    var medication: Medication
    @Binding var isPresented: Bool
    @State private var showReminderOptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Medication")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(medication.name ?? "Unknown")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding()

                Divider()

                VStack(alignment: .leading) {
                    Text("Dosage")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("\(medication.dosage?.amount ?? 0, specifier: "%.1f") \(medication.dosage?.unit ?? "mg")")
                        .font(.body)
                }
                .padding(.horizontal)
                
                Divider()

                Text("Today's Date: \(Date(), formatter: LogMedicationSheet.dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()

                Spacer()

                Button(action: {
                    markMedicationAsTaken()
                    isPresented = false
                }) {
                    Text("Mark as Taken")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(22)
                }
                .padding(.horizontal)

                Button(action: {
                    isPresented = false
                }) {
                    Text("Mark as Not Taken")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 44)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(22)
                }
                .padding([.horizontal])

                Button(action: {
                    showReminderOptions = true
                }) {
                    HStack {
                        Image(systemName: "bell")
                        Text("Remind Me")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(22)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Medication Details")
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
        .sheet(isPresented: $showReminderOptions) {
            ReminderOptionsView(medication: medication, isPresented: $showReminderOptions)
        }
    }

    private func markMedicationAsTaken() {
            // Find today's MedicationDateStatus or create it if it doesn't exist
            let today = Calendar.current.startOfDay(for: Date())
            
        if let dateStatus = medication.dateStatusArray.first(where: { $0.date == today }) {
                // Assuming MedicationDateStatus has a 'taken' attribute
                dateStatus.taken = true
            } /*else {
                // Handle the case where there is no dateStatus for today (create a new one or log an error)
                // For example, creating a new MedicationDateStatus object:
                let newDateStatus = MedicationDateStatus(context: moc)
                newDateStatus.date = today
                newDateStatus.taken = true
                medication.addToDatesToTake(newDateStatus)
            }*/

            do {
                try moc.save()
            } catch {
                print("Could not mark medication as taken: \(error.localizedDescription)")
            }
        }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
}
