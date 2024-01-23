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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer (for: Workout.self)
    }
}
