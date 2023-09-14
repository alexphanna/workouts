//
//  Workout.swift
//  Workouts
//
//  Created by Alex Hanna on 9/13/23.
//

import SwiftUI

struct Workout {
    var name: String
    var exerices: [Exercise] = []
}

struct WorkoutView: View {
    var workout: Workout
    init(name: String) {
        workout = Workout(name: name)
    }
    var body: some View {
        NavigationView {
            List {
                ExerciseView(name: "Bench Press")
                ExerciseView(name: "Incline Bench Press")
            }
            .navigationTitle(workout.name)
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
