//
//  Set.swift
//  Workouts
//
//  Created by Alex on 1/21/24.
//

import SwiftData
import SwiftUI

@Model
class Set: Identifiable {
    var reps: Int
    var weight: Int
    @Attribute(.unique) var id: UUID
    init(reps: Int, weight: Int) {
        self.reps = reps
        self.weight = weight
        id = UUID()
    }
}
