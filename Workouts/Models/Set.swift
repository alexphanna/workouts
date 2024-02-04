//
//  Set.swift
//  Workouts
//
//  Created by Alex on 1/25/24.
//

import SwiftData
import SwiftUI

@Model
class Set {
    var reps: Int
    var weight: Int
    var number: Int
    
    public var description: String {
        if UserDefaults.standard.integer(forKey: "measurementSystem") == 0 {
            return reps.description + " × " + weight.description + " kgs"
        }
        return reps.description + " × " + weight.description + " lbs"
    }
    
    init(reps: Int, weight: Int, number: Int) {
        self.reps = reps
        self.weight = weight
        self.number = number
    }
}
