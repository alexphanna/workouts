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
    
    init(reps: Int, weight: Int) {
        self.reps = reps
        self.weight = weight
    }
}
