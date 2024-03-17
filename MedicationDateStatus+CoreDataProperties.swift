//
//  MedicationDateStatus+CoreDataProperties.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/13/24.
//
//

import Foundation
import CoreData


extension MedicationDateStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedicationDateStatus> {
        return NSFetchRequest<MedicationDateStatus>(entityName: "MedicationDateStatus")
    }

    @NSManaged public var date: Date?
    @NSManaged public var taken: Bool
    @NSManaged public var medication: Medication?

}

extension MedicationDateStatus : Identifiable {

}
