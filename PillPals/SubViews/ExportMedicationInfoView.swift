import SwiftUI

struct ExportMedicationInfoView: View {
    @State private var isPDFExported = false
    
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
            (medication: "Medication 2", missedDoses: 1, totalDoses: 8)
        ] // Example medication history with missed doses information
        
        let pdfExporter = PDFExporter()
        
        if let pdfData = pdfExporter.exportMedicationHistoryToPDF(medicationHistory: medicationHistory) {
            // Dismiss any presented view controllers first
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.dismiss(animated: false) {
                    // Present the UIActivityViewController
                    let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                    rootViewController.present(activityViewController, animated: true, completion: nil)
                }
            }
            isPDFExported = true
        }
    }

}

struct ExportMedicationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ExportMedicationInfoView()
    }
}

// pdf exporter:
import UIKit
import PDFKit

class PDFExporter {
    
    func exportMedicationHistoryToPDF(medicationHistory: [(medication: String, missedDoses: Int, totalDoses: Int)]) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "PillPals",
            kCGPDFContextAuthor: "Admin"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792), format: format)
        
        let data = renderer.pdfData { context in
            let pageCount = medicationHistory.count
            for i in 0..<pageCount {
                context.beginPage()
                let medication = medicationHistory[i].medication
                let missedDoses = medicationHistory[i].missedDoses
                let totalDoses = medicationHistory[i].totalDoses
                let percentageMissed = Double(missedDoses) / Double(totalDoses) * 100
                
                let titleText = "Medication: \(medication)"
                let missedDosesText = "Missed Doses: \(missedDoses)"
                let totalDosesText = "Total Doses: \(totalDoses)"
                let percentageText = "Percentage Missed: \(percentageMissed)%"
                
                let text = "\(titleText)\n\(missedDosesText)\n\(totalDosesText)\n\(percentageText)"
                let attributedText = NSAttributedString(string: text)
                attributedText.draw(in: CGRect(x: 50, y: 50, width: 512, height: 692))
            }
        }
        return data
    }
}
