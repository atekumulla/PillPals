//
//  MedicationView.swift
//  PillAppTestTesting
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
    @State private var color: Color = Color(red: 180.0/255.0, green: 200.0/255.0, blue: 220.0/255.0)
    var medication: Medication
    @State private var isDatesListExpanded: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DisplayMedicationView(medication: medication, color: color)
                
                Divider()
                
                VStack {
                    HStack {
                        Text("Time Period:")
                            .bold()
                        Image(systemName: medication.period ?? "clock.arrow.circlepath")
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time to Take:")
                            .bold()
                        Text(medication.timeToTake!, style: .time)
                    }
                    
                    HStack {
                        Text("Start Date:")
                            .bold()
                        Text(formatDate(medication.startDate))
                    }
                    
                    HStack {
                        Text("End Date:")
                            .bold()
                        Text(formatDate(medication.endDate))
                    }
                }
                    /*Group {
                    HStack {
                        Text("Time Period:")
                            .bold()
                        Image(systemName: medication.period ?? "clock.arrow.circlepath")
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time to Take:")
                            .bold()
                        Text(medication.timeToTake, style: .time)
                    }
                    
                    HStack {
                        Text("Start Date:")
                            .bold()
                        Text(formatDate(medication.startDate))
                    }
                    
                    HStack {
                        Text("End Date:")
                            .bold()
                        Text(formatDate(medication.endDate))
                    }
                }
                .padding(.vertical, 1)*/
                
                CalendarView(medication: medication)
                    .padding()
                
                DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                    VStack(alignment: .leading, spacing: 5) {
                        // Assuming datesToTake properly initialized and iterable
                        ForEach(medication.dateStatusArray, id: \.date) { dateStatus in
                            HStack {
                                Text(formatDate(dateStatus.date))
                                Spacer()
                                Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(dateStatus.taken ? .green : .gray)
                            }
                        }
                    }
                    .padding()
                }
                .accentColor(.primary)
            }
            .padding()
        }
        .navigationTitle("\(medication.name ?? "Medication")")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct DisplayMedicationView: View {
    var medication: Medication
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "pills")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(medication.name ?? "Unknown")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Text("\(medication.dosage?.amount ?? 0, specifier: "%.1f") \(medication.dosage?.unit ?? "mg")")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "hand.tap.fill")
                    .foregroundColor(.primary)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.5)))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
}

/*
// RoundedDetailCard is a new view that will create a rounded rectangle card for a detail
struct RoundedDetailCard: View {
    var label: String
    var detail: String

    var body: some View {
        HStack {
            Text(label + ":")
                .bold()
            Spacer()
            Text(detail)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.05)))
        .frame(height: 70) // Or any other height you prefer
    }
        
}

struct CntView: View {
     
    var medication: Medication // Add this to accept medication object
    var size: CGSize
    var safeAreas: EdgeInsets
    /// View Properties
    @State private var offsetY: CGFloat = 0
    @State private var isDatesListExpanded: Bool = false // To control the expandable list
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView()
                // making to top
                    .zIndex(1000)
                SampleCardsView()
            }
            
            .background {
                ScrollDetector { offset in
                    offsetY = -offset
                } onDraggingEnd: { offset, velocity in
                    print("scroll released")
                }
            }
        }
    }
    
    // headerview
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = (size.height * 0.3) + safeAreas.top
        let minimumHeaderHeight = 65 + safeAreas.top
        /// converting offset into progres
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeight),1),0)
        // need a progers from 0-1 to be able to scale image
        // detials in kavsoft video
        
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(sampleColor.gradient)
                
                // med info
                VStack(spacing: 15) {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        /// sicne scaling of img is 0.3 (1-0.7)
                        let halfScaledHeight = (rect.height * 0.3) * 0.5
                        let midY = rect.midY
                        let bottomPadding: CGFloat = 15
                        let resizedOffsetY = (midY - (minimumHeaderHeight - halfScaledHeight - bottomPadding))
                        Image(systemName: "pills.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: rect.width, height: rect.height)
                            .clipShape(Circle())
                        /// scaling image
                            .scaleEffect(1 - (progress * 0.7), anchor: .leading)
                        /// moving scaled effect to center leading
                        // for left -(rect.minX - 15)
                            .offset(x: (rect.maxX - 60) * progress, y: -resizedOffsetY * progress)
                    }
                    .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                    
                    
                    Text("\(medication.name!)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    /// Scale tesxt a bit
                        .scaleEffect(1 - (progress * 0.15))
                    /// moving text a bit
                    /// 4.5 - 15 (spacing) / 0.3 (image scaling)
                        .offset(y: -4.5 * progress)
                }
                .padding(.top, safeAreas.top)
                .padding(.bottom, 15)
            }
            /// resiszing header heigh
            .frame(height: (headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY), alignment: .bottom)
            // Stikcing to top
            .offset(y: -offsetY)
        }
        .frame(height: headerHeight)
    }
    
    
    /// Sample row cards
    @ViewBuilder
    func SampleCardsView() -> some View {
        VStack() {
            // You can create a custom view for each medication detail.
            // Here's an example for priority, which you can replicate for other data points.
            RoundedDetailCard(label: "Dosage", detail: "\(medication.dosage!.amount) \(medication.dosage!.unit)")
                .padding(10)
            RoundedDetailCard(label: "Time To Take", detail: "\(medication.timeToTake!.formatted(date: .omitted, time: .shortened))")
                .padding(10)
            RoundedDetailCard(label: "Time Period", detail: medication.medicationPeriod!.rawValue)
                .padding(10)
            RoundedDetailCard(label: "Start Date", detail: medication.startDate!.formatted(date: .abbreviated, time: .omitted))
                .padding(10)
            RoundedDetailCard(label: "End Date", detail: medication.endDate!.formatted(date: .abbreviated, time: .omitted))
                .padding(10)
            
            
            // CalendarView should be treated separately since it's not a simple label-detail pair
            //CalendarView(medication: dummyMed)
                //.padding()
                //.background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            
            // Dosing Schedule
            DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                VStack(alignment: .leading, spacing: 5) {
                    // Assuming datesToTake properly initialized and iterable
                    ForEach(medication.dateStatusArray, id: \.date) { dateStatus in
                        HStack {
                            Text(formatDate(dateStatus.date!))
                            Spacer()
                            Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(dateStatus.taken ? .green : .gray)
                        }
                    }
                }
                .padding()
            }
            .padding(15)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}


struct NewMedicationDisplayView: View {
    var medication: Medication // Accept medication object
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreas = $0.safeAreaInsets
            
            // Pass medication object to CntView
            CntView(medication: medication, size: size, safeAreas: safeAreas)
                .ignoresSafeArea(.all, edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}
*/


/*
struct NewMedicationDisplayView_Preview: PreviewProvider {
    static var previews: some View {
        NewMedicationDisplayView()
    }
}*/

/*
struct CornerRadiusShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MedicationDetailView: View {
    @State private var color: Color = Color(red: 180.0/255.0, green: 200.0/255.0, blue: 220.0/255.0)
    var medication: Medication
    @State private var isDatesListExpanded: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DisplayMedicationView(medication: medication, color: color)
                
                Divider()
                
                    /*Group {
                    HStack {
                        Text("Time Period:")
                            .bold()
                        Image(systemName: medication.period ?? "clock.arrow.circlepath")
                            .foregroundColor(.primary)
                    }
                    
                    HStack {
                        Text("Time to Take:")
                            .bold()
                        Text(medication.timeToTake, style: .time)
                    }
                    
                    HStack {
                        Text("Start Date:")
                            .bold()
                        Text(formatDate(medication.startDate))
                    }
                    
                    HStack {
                        Text("End Date:")
                            .bold()
                        Text(formatDate(medication.endDate))
                    }
                }
                .padding(.vertical, 1)*/
                
                CalendarView(medication: medication)
                    .padding()
                
                DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                    VStack(alignment: .leading, spacing: 5) {
                        // Assuming datesToTake properly initialized and iterable
                        ForEach(medication.dateStatusArray, id: \.date) { dateStatus in
                            HStack {
                                Text(formatDate(dateStatus.date))
                                Spacer()
                                Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                                    .foregroundColor(dateStatus.taken ? .green : .gray)
                            }
                        }
                    }
                    .padding()
                }
                .accentColor(.primary)
            }
            .padding()
        }
        .navigationTitle("\(medication.name ?? "Medication")")
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct DisplayMedicationView: View {
    var medication: Medication
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "pills")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
                    .imageScale(.large)
                
                VStack(alignment: .leading) {
                    Text(medication.name ?? "Unknown")
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                    Text("\(medication.dosage?.amount ?? 0, specifier: "%.1f") \(medication.dosage?.unit ?? "mg")")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                Spacer()
                Image(systemName: "hand.tap.fill")
                    .foregroundColor(.primary)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                            .fill(color.opacity(0.5)))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
}
*/
