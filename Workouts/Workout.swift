//
//  Workout.swift
//  Workouts
//
//  Created by Alex on 1/5/24.
//

import SwiftData
import SwiftUI

@Model
class Workout: Identifiable {
    var name: String
    var date: Date
    var exerciseNames: [String] = []
    var exerciseReps: [[Int]] = []
    var exerciseWeights: [[Int]] = []
    @Attribute(.unique) var id: UUID
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        self.id = UUID()
    }
}
