//
//  Set+CoreDataClass.swift
//  Workouts
//
//  Created by Alex on 2/19/24.
//
//

import CoreData
import SwiftUI


public class Set: NSManagedObject {
    @AppStorage("unit") private var unit: String = "lb"
    
    public override var description: String {
        if unit == "lb" && weight != 1 {
            return reps.description + " x " + weight.description + " lbs"
        }
        return reps.description + " x " + weight.description + " " + unit
    }
    public var volume: Float {
        return Float(reps) * weight
    }
}
