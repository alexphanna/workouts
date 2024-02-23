//
//  Set+CoreDataClass.swift
//  Workouts
//
//  Created by Alex on 2/19/24.
//
//

import Foundation
import CoreData


public class Set: NSManagedObject {
    public override var description: String {
        return reps.description + " x " + weight.description
    }
    public var volume: Int16 {
        return reps * weight
    }
}
