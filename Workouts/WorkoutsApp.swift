//
//  WorkoutsApp.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftData
import SwiftUI

@main
struct WorkoutsApp: App {
    private var defaultExercises = ["Squat", "Leg press", "Lunge", "Deadlift", "Leg extension", " Leg curl", "Standing calf raise", "Seated calf raise", "Bench press", "Chest fly", "Push-up", "Pull-down", "Pull-up", "Bent-over row", "Upright row", "Shoulder press", "Lateral raise", "Shouldder shrug", "Pushdown", "Triceps extension", "Bicep curl", "Crunch", "Russian twist", "Leg raise", "Back extension"]
    
    private var defaultEquipment = ["Barbell", "Dumbbell", "Kettlebell", "Machine", "None"]
    
    init() {
        if((UserDefaults.standard.array(forKey: "exerciseNames") as? [String] ?? [String]()).count == 0) {
            UserDefaults.standard.set(defaultExercises, forKey: "exerciseNames")
        }
        if((UserDefaults.standard.array(forKey: "equipmentNames") as? [String] ?? [String]()).count == 0) {
            UserDefaults.standard.set(defaultEquipment, forKey: "equipmentNames")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer (for: Workout.self)
    }
}
