//
//  MedCodableDataStore.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 11/29/23.
//
/*

import Foundation

@MainActor
class MedStore: ObservableObject {
    @Published var meds: [Medication] = []
    
    init() {
        Task {
            do {
                try await load()
            } catch {
                self.meds = [] // Use dummy data if no saved data exists
            }
        }
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("meds.data")
        
    }
    
    private func sortMedicationsByTime() {
        meds.sort { $0.timeToTake < $1.timeToTake}
    }
    
    func addMedication(_ medication: Medication) {
        meds.append(medication)
        sortMedicationsByTime()
    }
    
    
    
    func load() async throws {
        let task = Task<[Medication], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dailyMeds = try JSONDecoder().decode([Medication].self, from: data)
            return dailyMeds
        }
        let meds = try await task.value
        self.meds = meds.sorted { $0.timeToTake < $1.timeToTake }
        //self.meds = meds
    }
    
    func save(medications: [Medication]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(meds)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
*/
