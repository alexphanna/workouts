//
//  Exercise+CoreDataProperties.swift
//  Workouts
//
//  Created by Alex on 2/19/24.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var notes: String
    @NSManaged public var name: String
    @NSManaged public var equipment: String
    @NSManaged public var sets: NSOrderedSet
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for sets
extension Exercise {

    @objc(insertObject:inSetsAtIndex:)
    @NSManaged public func insertIntoSets(_ value: Set, at idx: Int)

    @objc(removeObjectFromSetsAtIndex:)
    @NSManaged public func removeFromSets(at idx: Int)

    @objc(insertSets:atIndexes:)
    @NSManaged public func insertIntoSets(_ values: [Set], at indexes: NSIndexSet)

    @objc(removeSetsAtIndexes:)
    @NSManaged public func removeFromSets(at indexes: NSIndexSet)

    @objc(replaceObjectInSetsAtIndex:withObject:)
    @NSManaged public func replaceSets(at idx: Int, with value: Set)

    @objc(replaceSetsAtIndexes:withSets:)
    @NSManaged public func replaceSets(at indexes: NSIndexSet, with values: [Set])

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: Set)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: Set)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSOrderedSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}

extension Exercise : Identifiable {

}
