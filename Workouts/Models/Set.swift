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
    
    public var description: String {
        return reps.description + " x " + weight.description
    }
    
    init(reps: Int, weight: Int) {
        self.reps = reps
        self.weight = weight
    }
}
