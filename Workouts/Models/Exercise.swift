//
//  Exercise.swift
//  Workouts
//
//  Created by Alex on 1/25/24.
//

import SwiftData
import SwiftUI

@Model
class Exercise {
    var name: String
    var sets: [Set]
    var number: Int
    
    init(name: String, number: Int) {
        self.name = name
        self.sets = []
        self.number = number
    }
}
