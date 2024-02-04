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
    var date: Date
    var notes: String
    
    public var description: String {
        if equipment.description == "None" {
            return name.description.capitalized
        }
        return (equipment.description + " " + name.description).capitalized
    }
    
    init(name: String, equipment: String) {
        self.name = name
        self.equipment = equipment
        self.sets = []
        self.date = Date.now
        self.notes = ""
    }
}
