//
//  Exercise+CoreDataProperties.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String

}

extension Exercise : Identifiable {

}
