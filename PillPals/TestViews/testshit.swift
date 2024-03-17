//
//  testshit.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/6/24.
//

import Foundation
import SwiftUI

struct TestMedicationView: View {
    let medication: TestMedication // Assume you have a Medication model

    @State private var scrollOffset: CGFloat = 0
    @State private var headerHeight: CGFloat = UIScreen.main.bounds.height / 3

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                header
                medicationDetails
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(OffsetPreferenceKey.self) { offsetValue in
            let offsetY = offsetValue.minY
            let progress = offsetY / headerHeight

            // Update the header height based on scroll offset
            headerHeight = max(headerHeight - offsetY, 100)

            // Update the pill symbol size and position based on scroll offset
            let symbolSize = 50 - (50 * progress)
            let symbolOffset = max(0, min(200 * progress, 200))

            // Update the state variables
            scrollOffset = offsetY
        }
    }

    private var header: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                    .frame(height: headerHeight)

                Image(systemName: "pill")
                    .font(.system(size: 100 - (100 * scrollOffset / headerHeight)))
                    .offset(x: scrollOffset / headerHeight * 200, y: 0)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
        }
        .frame(height: headerHeight)
    }

    private var medicationDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(medication.name)
                .font(.title)
                .padding(.top, 16)

            Text("Description:")
                .font(.headline)
            Text(medication.description)

            Text("Dosage:")
                .font(.headline)
            Text(medication.dosage)

            Text("Side Effects:")
                .font(.headline)
            ForEach(medication.sideEffects, id: \.self) { sideEffect in
                Text("• \(sideEffect)")
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}

struct ShitMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationView(medication: TestMedication(name: "Ibuprofen", description: "An anti-inflammatory medication", dosage: "200mg every 6 hours", sideEffects: ["Nausea", "Heartburn", "Dizziness"]))
    }
}

// Offset Preference Key for tracking scroll offset
struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero

    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

// Sample Medication model
struct TestMedication {
    let name: String
    let description: String
    let dosage: String
    let sideEffects: [String]
}
