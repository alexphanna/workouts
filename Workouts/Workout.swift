//
//  Workout.swift
//  Workouts
//
//  Created by Alex on 1/5/24.
//

import SwiftUI

@Observable
class Workout: Identifiable {
    var name: String
    var date: Date
    var exercises: [Exercise]
    var id: UUID
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        self.exercises = []
        self.id = UUID()
    }
}
