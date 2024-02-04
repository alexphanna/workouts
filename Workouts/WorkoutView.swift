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
    @State private var exerciseNames = UserDefaults.standard.array(forKey: "exerciseNames") as? [String] ?? [String]()
    @State private var equipmentNames = UserDefaults.standard.array(forKey: "equipmentNames") as? [String] ?? [String]()
    @State private var name = ""
    @State private var nameIndex = 0
    @State private var equipmentIndex = 0
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
                                Picker("Name", selection: $nameIndex) {
                                    ForEach (0..<exerciseNames.count, id: \.self) { i in
                                        Text(exerciseNames[i])
                                    }
                                }
                            }
                            else {
                                TextField("Name", text: $name)
                            }
                            Picker("Equipment", selection: $equipmentIndex) {
                                ForEach (0..<equipmentNames.count, id: \.self) { i in
                                    Text(equipmentNames[i])
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
                                Button("Done", action: { addExercise() })
                            }
                        }
                    }
                }
                EditButton()
            }
    }
    
    func addExercise() {
        if (UserDefaults.standard.bool(forKey: "limitExercises")) {
            workout.exercises.append(Exercise(name: exerciseNames[nameIndex], equipment: equipmentNames[equipmentIndex], number: workout.exercises.count))
        }
        else {
            workout.exercises.append(Exercise(name: name, equipment: equipmentNames[equipmentIndex], number: workout.exercises.count))
        }
        isSheetShowing = false
    }
}

