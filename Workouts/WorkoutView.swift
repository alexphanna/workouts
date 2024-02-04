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
    @State private var newExerciseEquipment = ""
    @Bindable var workout: Workout
    
    var body: some View {
            VStack {
                List {
                    ForEach(workout.exercises.sorted { $0.number < $1.number }, id: \.self) { exercise in
                        Section {
                            ExerciseView(exercise: exercise)
                        }
                    }
                }
            }
            .navigationTitle(workout.name)
            .toolbar {
                Button(action: { isSheetShowing = true }) {
                    Image(systemName: "plus")
                }.sheet(isPresented: $isSheetShowing) {
                    NavigationView {
                        Form {
                            if (UserDefaults.standard.bool(forKey: "limitExercises")) {
                                Picker("Name", selection: $newExerciseName) {
                                    ForEach (UserDefaults.standard.array(forKey: "exerciseNames") as? [String] ?? [String](), id: \.self) { name in
                                        Text(name)
                                    }
                                }
                            }
                            else {
                                TextField("Name", text: $newExerciseName)
                            }
                            Picker("Equipment", selection: $newExerciseEquipment) {
                                ForEach (UserDefaults.standard.array(forKey: "equipmentNames") as? [String] ?? [String](), id: \.self) { equipment in
                                    Text(equipment)
                                }
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
    
    func addExercise() {
        if (newExerciseName.count > 0) {
            workout.exercises.append(Exercise(name: newExerciseName, equipment: newExerciseEquipment, number: workout.exercises.count))
            isSheetShowing = false
            newExerciseName = ""
        }
    }
}

