//
//  Dosage+CoreDataProperties.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/17/24.
//
//

import Foundation
import CoreData


extension Dosage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dosage> {
        return NSFetchRequest<Dosage>(entityName: "Dosage")
    }

    @NSManaged public var amount: Double
    @NSManaged public var unit: String?
    @NSManaged public var medication: Medication?

}

extension Dosage : Identifiable {

}

extension Dosage {
    var dosageUnit: DosageUnit? {
        guard let unitString = unit else {
            return nil
        }
        return DosageUnit(rawValue: unitString)
    }
}
