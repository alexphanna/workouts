//
//  WorkoutsApp.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//

import SwiftUI

@main
struct WorkoutsApp: App {
    let persistenceController = PersistenceController.shared
    private var defaultExercises = ["Squat", "Leg press", "Lunge", "Deadlift", "Leg extension", "Leg curl", "Standing calf raise", "Seated calf raise", "Bench press", "Chest fly", "Push-up", "Pull-down", "Pull-up", "Bent-over row", "Upright row", "Shoulder press", "Lateral raise", "Shouldder shrug", "Pushdown", "Triceps extension", "Bicep curl", "Crunch", "Russian twist", "Leg raise", "Back extension"].sorted { $0 < $1 }
    private var defaultEquipment = ["Barbell", "Dumbbell", "Kettlebell", "Machine", "None"].sorted { $0 < $1 }
    
    init() {
        if (UserDefaults.standard.stringArray(forKey: "defaultExercises") ?? [String]()).count == 0 {
            UserDefaults.standard.set(defaultExercises, forKey: "defaultExercises")
        }
        if (UserDefaults.standard.stringArray(forKey: "defaultEquipment") ?? [String]()).count == 0 {
            UserDefaults.standard.set(defaultEquipment, forKey: "defaultEquipment")
        }
    }
        

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
