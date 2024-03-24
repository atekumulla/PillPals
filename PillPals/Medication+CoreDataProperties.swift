//
//  Medication+CoreDataProperties.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/22/24.
//
//

import Foundation
import CoreData


extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication")
    }

    @NSManaged public var daysOfWeek: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var period: String?
    @NSManaged public var priority: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var timeToTake: Date?
    @NSManaged public var type: String?
    @NSManaged public var dateStatuses: NSSet?
    @NSManaged public var dosage: Dosage?
    @NSManaged public var rgbColor: RGBColor?

}

// MARK: Generated accessors for dateStatuses
extension Medication {

    @objc(addDateStatusesObject:)
    @NSManaged public func addToDateStatuses(_ value: MedicationDateStatus)

    @objc(removeDateStatusesObject:)
    @NSManaged public func removeFromDateStatuses(_ value: MedicationDateStatus)

    @objc(addDateStatuses:)
    @NSManaged public func addToDateStatuses(_ values: NSSet)

    @objc(removeDateStatuses:)
    @NSManaged public func removeFromDateStatuses(_ values: NSSet)

}

extension Medication : Identifiable {

}


extension Medication {

    

    var medicationType: MedicationType {

        

        get {

            

            MedicationType(rawValue: type ?? "") ?? .pill

            

        }

        

        set {

            

            type = newValue.rawValue

            

        }

        

    }

    

    var medicationPeriod: MedicationPeriod? {

        

        get {

            

            guard let periodString = self.period else { return nil }

            

            return MedicationPeriod(rawValue: periodString)

            

        }

        

        set {

            

            self.period = newValue?.rawValue

            

        }

        

    }

    

    var medicationPriority: Priority {

        

        get {

            

            Priority(rawValue: priority ?? "") ?? .normal

            

        }

        

        set {

            

            priority = newValue.rawValue

            

        }

        

    }

    var dateStatusArray: [MedicationDateStatus] {

        get {

            let set = dateStatuses as? Set<MedicationDateStatus> ?? []

            return Array(set)

        }

        set {

            dateStatuses = NSSet(array: newValue)

        }

    }

}


extension Medication {
    var daysOfWeekArray: [DayOfWeek] {
        get {
            // Convert the comma-separated string to an array of DayOfWeek
            let dayIndices = daysOfWeek?.components(separatedBy: ",").compactMap { Int($0) }
            return dayIndices?.compactMap { DayOfWeek(rawValue: "\($0)") } ?? []
        }
        set {
            // Convert the array of DayOfWeek to a comma-separated string
            let dayIndices = newValue.map { "\($0.calendarValue)" }.joined(separator: ",")
            daysOfWeek = dayIndices
        }
    }
}
