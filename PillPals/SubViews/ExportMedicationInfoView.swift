//
//  ExportMedicationInfoView.swift
//  PillPals
//
//  Created by anush on 3/24/24.
//

import SwiftUI
import Foundation
import AppIntents
import UserNotifications
import UserNotificationsUI
import Combine

struct ExportMedicationInfoView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest var medications: FetchedResults<Medication>
    @State private var isPDFExported = false
    @State private var isExportingInProgress = false // New state variable to track export progress
    let pdfExporter = PDFExporter()
    
    init() {
            // Calculate today's index
            let todayIndex = Calendar.current.component(.weekday, from: Date())
            // Ensure searchString correctly matches the stored format
            let searchString = "*\(todayIndex)*"

            // Initialize the fetch request
            _medications = FetchRequest<Medication>(
                sortDescriptors: [NSSortDescriptor(keyPath: \Medication.timeToTake, ascending: true)],
                predicate: NSPredicate(format: "daysOfWeek LIKE %@", searchString)
            )
        print("medication size: \(medications.count)")
        }

    var body: some View {
        VStack {
            Button(action: exportMedicationHistory) {
                Text("Export Medication History")
                    .fontWeight(.semibold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $isPDFExported) {
                Alert(
                    title: Text("Export Successful"),
                    message: Text("Medication history has been exported as PDF."),
                    dismissButton: .default(Text("OK"))
                )
            }
            Spacer()
        }
        .padding()
    }
    
    func exportMedicationHistory() {
        let medicationHistory = [
            (medication: "Medication 1", missedDoses: 2, totalDoses: 10),
            (medication: "Medication 2", missedDoses: 1, totalDoses: 8),
            (medication: "Medication 3", missedDoses: 0, totalDoses: 12),
            // Add more medications here
        ] // Example medication history with missed doses information
        
        isExportingInProgress = true
        
        let pdfExporter = PDFExporter()
        
        DispatchQueue.global().async {
            if let pdfData = pdfExporter.exportMedicationHistoryToPDF(medicationHistory: medicationHistory, medications: medications) {
                DispatchQueue.main.async {
                    isExportingInProgress = false // Set export progress to false
                    isPDFExported = true // Show alert
                    // Present the UIActivityViewController with pdfData
                    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                        rootViewController.dismiss(animated: false) {
                            // Present the UIActivityViewController
                            let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                            rootViewController.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
//        if let pdfData = pdfExporter.exportMedicationHistoryToPDF(medicationHistory: medicationHistory) {
//            // Dismiss any presented view controllers first
//            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
//                rootViewController.dismiss(animated: false) {
//                    // Present the UIActivityViewController
//                    let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
//                    rootViewController.present(activityViewController, animated: true, completion: nil)
//                }
//            }
//            isPDFExported = true
//        }
    }
}
//
//struct ExportMedicationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExportMedicationInfoView()
//    }
//}

class PDFExporter {
    func exportMedicationHistoryToPDF(medicationHistory: [(medication: String, missedDoses: Int, totalDoses: Int)], medications: FetchedResults<Medication>) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "PillPals",
            kCGPDFContextAuthor: "Admin"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792), format: format)
        
        let data = renderer.pdfData { context in
            // Page for listing medications
            context.beginPage()
            drawMedicationsList(in: context, medications: medications)
            
            // Page for medication history
            context.beginPage()
            drawMedicationHistory(medicationHistory, in: context)
        }
        return data
    }
    
    private func drawMedicationsList(in context: UIGraphicsPDFRendererContext, medications: FetchedResults<Medication>) {
        // Start at the top of the page
        var currentY: CGFloat = 50
        
        // Add title
        let titleText = "Medications List"
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        let titleSize = (titleText as NSString).size(withAttributes: titleAttributes)
        let titleRect = CGRect(x: (612 - titleSize.width) / 2, y: currentY, width: titleSize.width, height: titleSize.height)
        titleText.draw(in: titleRect, withAttributes: titleAttributes)
        currentY += titleSize.height + 20
        
        print("medications size: \(medications.count)")
        
        // Add each medication
        for medication in medications {
            if let dosage = medication.dosage {
//                let medicationText = "\(String(describing: medication.name)) - Type: \(String(describing: medication.type)), Dosage: \(dosage.amount) \(String(describing: dosage.unit))"
                let medicationText = "\(medication.name ?? "Unknown") - Type: \(medication.type ?? "Unknown"), Dosage: \(dosage.amount ?? 0) \(dosage.unit ?? "Unknown")"

                let medicationFont = UIFont.systemFont(ofSize: 16)
                let medicationAttributes: [NSAttributedString.Key: Any] = [.font: medicationFont]
                let medicationSize = (medicationText as NSString).size(withAttributes: medicationAttributes)
                let medicationRect = CGRect(x: 50, y: currentY, width: 512, height: medicationSize.height)
                medicationText.draw(in: medicationRect, withAttributes: medicationAttributes)
                currentY += medicationSize.height + 10
            }
        }
    }
    
    private func drawMedicationHistory(_ medicationHistory: [(medication: String, missedDoses: Int, totalDoses: Int)], in context: UIGraphicsPDFRendererContext) {
        // Start at the top of the page
        var currentY: CGFloat = 50
        
        // Add title
        let titleText = "Medication History"
        let titleFont = UIFont.boldSystemFont(ofSize: 24)
        let titleAttributes: [NSAttributedString.Key: Any] = [.font: titleFont]
        let titleSize = (titleText as NSString).size(withAttributes: titleAttributes)
        let titleRect = CGRect(x: (612 - titleSize.width) / 2, y: currentY, width: titleSize.width, height: titleSize.height)
        titleText.draw(in: titleRect, withAttributes: titleAttributes)
        currentY += titleSize.height + 20
        
        // Add each medication history entry
        for entry in medicationHistory {
            let medication = entry.medication
            let missedDoses = entry.missedDoses
            let totalDoses = entry.totalDoses
            let adherenceRate = 100.0 * (1.0 - Double(missedDoses) / Double(totalDoses))
            
            let medicationText = "Medication: \(medication)"
            let missedDosesText = "Missed Doses: \(missedDoses)"
            let totalDosesText = "Total Doses: \(totalDoses)"
            let adherenceRateText = String(format: "Adherence Rate: %.2f%%", adherenceRate)
            
            let entryText = "\(medicationText)\n\(missedDosesText)\n\(totalDosesText)\n\(adherenceRateText)"
            let entryFont = UIFont.systemFont(ofSize: 16)
            let entryAttributes: [NSAttributedString.Key: Any] = [.font: entryFont]
            let entrySize = (entryText as NSString).size(withAttributes: entryAttributes)
            let entryRect = CGRect(x: 50, y: currentY, width: 512, height: entrySize.height)
            entryText.draw(in: entryRect, withAttributes: entryAttributes)
            currentY += entrySize.height + 10
        }
    }

}

//#Preview {
//    ExportMedicationInfoView()
//}