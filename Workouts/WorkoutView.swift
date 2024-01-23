//
//  WorkoutView.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftData
import SwiftUI

struct WorkoutView: View {
    @State private var isSheetShowing = false
    @State private var newExerciseName = ""
    @State var workout: Workout
    
    var body: some View {
            VStack {
                /* List {
                    ForEach(workout.exercises) { exercise in
                        Section {
                            ExerciseView(exercise: exercise)
                        }
                    }
                } */
            }
            .navigationTitle(workout.name)
            .toolbar {
                Button(action: { isSheetShowing = true }) {
                    Image(systemName: "plus")
                }.sheet(isPresented: $isSheetShowing) {
                    NavigationView {
                        Form {
                            TextField("Name", text: $newExerciseName)
                        }
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", action: { isSheetShowing = false })
                            }
                            ToolbarItem(placement: .principal) {
                                Text("Add Exercise").font(.headline)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done", action: { addExercise() }).disabled(newExerciseName.count == 0)
                            }
                        }
                    }
                }
                EditButton()
            }
    }
    
    func addExercise() {
        if (newExerciseName.count > 0) {
            //workout.exercises.append(Exercise(name: newExerciseName))
            isSheetShowing = false
            newExerciseName = ""
        }
    }
}

