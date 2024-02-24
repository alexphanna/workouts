//
//  Exercise+CoreDataClass.swift
//  Workouts
//
//  Created by Alex on 2/19/24.
//
//

import Foundation
import CoreData


public class Exercise: NSManagedObject {
    public override var description: String {
        if equipment == "None" {
            return name.capitalized
        }
        else {
            return (equipment + " " + name).capitalized
        }
    }
    public var averageReps: Double {
        var sum = 0
        for set in sets.array as? [Set] ?? [Set]() {
            sum += Int(set.reps)
        }
        return Double(sum) / Double(sets.array.count)
    }
    public var averageWeights: Double {
        var sum = 0
        for set in sets.array as? [Set] ?? [Set]() {
            sum += Int(set.weight)
        }
        return Double(sum) / Double(sets.array.count)
    }
    public var volume: Int {
        var volume = 0
        for set in sets.array as? [Set] ?? [Set]() {
            volume += Int(set.volume)
        }
        return volume
    }
}
