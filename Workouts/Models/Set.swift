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
    var date: Date
    
    public var description: String {
        return reps.description + " × " + weight.description + " " + (UserDefaults.standard.string(forKey: "measurementSystem") ?? "")
    }
    
    init(reps: Int, weight: Int) {
        self.reps = reps
        self.weight = weight
        self.date = Date.now
    }
    
    public var volume: Int {
        return reps * weight
    }
}
