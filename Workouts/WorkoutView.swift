//
//  WorkoutView.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftUI

struct WorkoutView: View {
    @State private var exercises: [Exercise] = [ Exercise(name: "Bench Press") ]
    @State private var isSheetShowing = false
    @State private var newExerciseName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(exercises) { exercise in
                        Section {
                            ExerciseView(exercise: exercise)
                        }
                    }
                }
            }
            .navigationTitle("Push")
            .toolbar {
                Button(action: { isSheetShowing = true }) {
                    Image(systemName: "plus")
                }.sheet(isPresented: $isSheetShowing) {
                    NavigationView {
                        Form {
                            HStack {
                                Text("Name")
                                TextField("bench press", text: $newExerciseName).multilineTextAlignment(.trailing)
                            }
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
    }
    
    func addExercise() {
        if (newExerciseName.count > 0) {
            exercises.append(Exercise(name: newExerciseName))
            isSheetShowing = false
        }
    }
}

