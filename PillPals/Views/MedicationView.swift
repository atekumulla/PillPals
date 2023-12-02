//
//  MedicationView.swift
//  PillAppTesting
//
//  Created by Aadi Shiv Malhotra on 11/12/23.
//

import Foundation

import SwiftUI


struct CornerRadiusShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MedicationDetailView: View {
    @State var medication: Medication
    @State private var isDatesListExpanded: Bool = false // To control the expandable list
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            /*ZStack {
                HStack {
                    Image(systemName: "pills.circle") // Placeholder image for medication
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(medication.uiColor)
                    
                    VStack(alignment: .leading) {
                        Text(medication.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(medication.uiColor)
                        
                        Text("\(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }*/
            
            DisplayMedicationView(medication: medication)
            Divider()
            ScrollView {
                
                VStack(alignment: .leading, spacing: 10) { // Leading alignment and spacing between elements
                    HStack {
                        Text("Type:")
                            .bold()
                        Text(medication.type.rawValue.capitalized)
                    }
                    
                    
                    HStack {
                        Text("Priority:")
                            .bold()
                        Text(medication.priority.rawValue.capitalized)
                            .foregroundColor(medication.priority == .high ? .red : .primary)
                    }
                    
                    HStack {
                        Text("Time Period:")
                            .bold()
                        Image(systemName: medication.period.rawValue)
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time to take:")
                            .bold()
                        Text(medication.timeToTake, style: .time)
                    }
                    
                    HStack {
                        Text("Start Date:")
                            .fontWeight(.semibold)
                        Text(formatDate(medication.startDate))
                    }
                    
                    HStack {
                        Text("End Date:")
                            .fontWeight(.semibold)
                        Text(formatDate(medication.endDate))
                    }
                    
                    CalendarView(medication: medication)
                        .padding()
                    
                    DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                        VStack(alignment: .leading) {
                            ForEach(medication.datesToTake, id: \.date) { dateStatus in
                                HStack {
                                    Text(formatDate(dateStatus.date))
                                    Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        .padding()
                    }
                    .accentColor(.primary)
                }
                .padding() // Padding for the VStack
            }

            
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct MedicationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationDetailView(medication: dummyMedications[1])
    }
}

struct DisplayMedicationView: View {
    var medication: Medication

    var body: some View {
        VStack(alignment: .leading) {
 
            
            HStack {
                Image(systemName: medication.period.rawValue)
                    //.resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(medication.color.color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(medication.name)
                        .font(.largeTitle
                        )
                        .foregroundColor(.primary)
                    Text("\(medication.dosage.amount, specifier: "%.1f") \(medication.dosage.unit.rawValue)")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "hand.tap.fill")
                    //.foregroundStyle(.secondary)
                    .foregroundColor(.primary)
            
                    
                
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                                        .fill(medication.uiColor.opacity(0.5)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(medication.uiColor, lineWidth: 2)
                        )
        }
        //.padding(.vertical, 4)

    }
}

/*struct MedicationDetailView: View {
    var medication: Medication
    
    
    @State private var currentDate = Date()

    @State private var isDatesListExpanded: Bool = false // To control the expandable list

       var body: some View {
           ScrollView {
               VStack(spacing: 20) {
                   GeometryReader { geometry in
                      ZStack(alignment: .bottom) {
                          Rectangle()
                              .foregroundColor(medication.color)
                              .frame(height: geometry.size.height * 0.5) // 15% of the screen height
                              //.cornerRadius(10, corners: [.bottomLeft, .bottomRight])

                          Image(systemName: "pills.circle")
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 100, height: 100)
                              .background(Circle().fill(Color.white))
                              .overlay(
                                  Circle()
                                      .stroke(Color.white, lineWidth: 4)
                            )
                            .offset(y: 25) // Half inside the rectangle
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.3) // Here we set the height for the ZStack

                  // Spacer()

                   VStack(alignment: .leading, spacing: 10) {
                       Text(medication.name)
                           .font(.largeTitle)
                           .fontWeight(.bold)

                       // ... other details ...
                       

                       HStack {
                           Text("Type:")
                               .fontWeight(.semibold)
                           Text(medication.type.rawValue.capitalized)
                       }
                       
                       HStack {
                           Text("Time to take: ")
                               .fontWeight(.semibold)
                           Text(formatTime(medication.timeToTake))
                       }

                       HStack {
                           Text("Start Date:")
                               .fontWeight(.semibold)
                           Text(formatDate(medication.startDate))
                       }

                       HStack {
                           Text("End Date:")
                               .fontWeight(.semibold)
                           Text(formatDate(medication.endDate))
                       }

                       HStack {
                           Text("Priority:")
                               .fontWeight(.semibold)
                           Text(medication.priority.rawValue.capitalized)
                       }
                       
                       CalendarView(medication: medication)
                                           .padding()

                       DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                           VStack(alignment: .leading) {
                               ForEach(medication.datesToTake, id: \.date) { dateStatus in
                                   HStack {
                                       Text(formatDate(dateStatus.date))
                                        Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                   }
                               }
                           }
                           .padding()
                       }
                       .accentColor(.primary)
                   }
                   .padding()
               }
           }
           .navigationBarTitle("Medication Info", displayMode: .inline)
       }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }

    private func DetailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Text(value)
        }
    }
}*/


/*enum DayOfWeek: String, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday

    var title: String {
        self.rawValue.capitalized
    }
}*/

/*
struct MedicationDetailView: View {
    var medication: Medication

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(medication.name)
                .font(.title)
                .fontWeight(.bold)

            HStack {
                Text("Type:")
                    .fontWeight(.semibold)
                Text(medication.type.rawValue.capitalized)
            }

            HStack {
                Text("Start Date:")
                    .fontWeight(.semibold)
                Text(formatDate(medication.startDate))
            }

            HStack {
                Text("End Date:")
                    .fontWeight(.semibold)
                Text(formatDate(medication.endDate))
            }

            HStack {
                Text("Priority:")
                    .fontWeight(.semibold)
                Text(medication.priority.rawValue.capitalized)
            }

            Text("Dosing Schedule")
                .font(.headline)
                .padding(.top)

            VStack(alignment: .leading) {
                ForEach(medication.datesToTake, id: \.self) { date in
                    Text(formatDate(date))
                }
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Medication Info", displayMode: .inline)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
*/
