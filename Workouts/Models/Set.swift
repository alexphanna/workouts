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
    var warmup: Bool
    var date: Date
    
    init(reps: Int, weight: Int, warmup: Bool = false) {
        self.reps = reps
        self.weight = weight
        self.warmup = warmup
        self.date = Date.now
    }
    
    public var description: String {
        return reps.description + " × " + weight.description + " " + (UserDefaults.standard.string(forKey: "measurementSystem") ?? "")
    }
    
    public var volume: Int {
        return reps * weight
    }
}
