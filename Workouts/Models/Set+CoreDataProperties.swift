//
//  Set+CoreDataProperties.swift
//  Workouts
//
//  Created by Alex on 2/19/24.
//
//

import Foundation
import CoreData


extension Set {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Set> {
        return NSFetchRequest<Set>(entityName: "Set")
    }

    @NSManaged public var reps: Int16
    @NSManaged public var weight: Int16
    @NSManaged public var exercise: Exercise

}

extension Set : Identifiable {

}
