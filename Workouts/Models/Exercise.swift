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
    
    init(name: String) {
        self.name = name
        self.sets = []
    }    
}
