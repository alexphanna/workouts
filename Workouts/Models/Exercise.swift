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
    var equipment: String
    var sets: [Set]
    var number: Int
    
    public var description: String {
        if equipment.description == "None" {
            return name.description
        }
        return equipment.description + " " + name.description
    }
    
    init(name: String, equipment: String, number: Int) {
        self.name = name
        self.equipment = equipment
        self.sets = []
        self.number = number
    }
}
