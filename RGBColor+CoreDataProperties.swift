//
//  RGBColor+CoreDataProperties.swift
//  PillPals
//
//  Created by Aadi Shiv Malhotra on 3/13/24.
//
//

import Foundation
import CoreData


extension RGBColor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RGBColor> {
        return NSFetchRequest<RGBColor>(entityName: "RGBColor")
    }

    @NSManaged public var red: Double
    @NSManaged public var blue: Double
    @NSManaged public var green: Double
    @NSManaged public var alpha: Double
    @NSManaged public var medication: Medication?

}

extension RGBColor : Identifiable {

}
