//
//  Workout+CoreDataProperties.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var name: String
    @NSManaged public var date: Date
    @NSManaged public var exercises: [Exercise]

}

extension Workout : Identifiable {

}
