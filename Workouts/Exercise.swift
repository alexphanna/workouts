//
//  Exercise.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftData
import SwiftUI

class Exercise: Identifiable {
    var name: String
    var sets: [Set]
    var id: UUID
    init(name: String) {
        self.name = name
        self.sets = []
        self.id = UUID()
    }
}
