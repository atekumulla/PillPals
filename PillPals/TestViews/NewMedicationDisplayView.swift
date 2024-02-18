//
//  NewMedicationDisplayView.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 2/17/24.
//

import Foundation
import SwiftUI

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
                    
                    
                    Text("\(dummyMed.name)")
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
            RoundedDetailCard(label: "Dosage", detail: "\(dummyMed.dosage.amount) \(dummyMed.dosage.unit)")
                .padding(10)
            RoundedDetailCard(label: "Priority", detail: dummyMed.priority.rawValue.capitalized)
                .padding(10)
            RoundedDetailCard(label: "Time To Take", detail: "\(dummyMed.timeToTake.formatted(date: .omitted, time: .shortened))")
                .padding(10)
            RoundedDetailCard(label: "Time Period", detail: dummyMed.period.rawValue.capitalized)
                .padding(10)
            RoundedDetailCard(label: "Start Date", detail: dummyMed.startDate.formatted(date: .abbreviated, time: .omitted))
                .padding(10)
            RoundedDetailCard(label: "End Date", detail: dummyMed.endDate.formatted(date: .abbreviated, time: .omitted))
                .padding(10)
            
            
            // CalendarView should be treated separately since it's not a simple label-detail pair
            //CalendarView(medication: dummyMed)
                //.padding()
                //.background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            
            // Dosing Schedule
            DisclosureGroup("Dosing Schedule", isExpanded: $isDatesListExpanded) {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(dummyMed.datesToTake, id: \.date) { dateStatus in
                        HStack {
                            Text(formatDate(dateStatus.date))
                            Spacer()
                            Image(systemName: dateStatus.taken ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(dateStatus.taken ? .green : .secondary)
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
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeAreas = $0.safeAreaInsets
            
            CntView(size: size, safeAreas: safeAreas)
                .ignoresSafeArea(.all, edges: .top)
        }
        .toolbar(.hidden, for: .navigationBar)

    }
}



struct NewMedicationDisplayView_Preview: PreviewProvider {
    static var previews: some View {
        NewMedicationDisplayView()
    }
}

