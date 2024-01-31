//
//  SettingsView.swift
//  Workouts
//
//  Created by Alex on 1/21/24.
//

import SwiftUI

struct SettingsView : View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @AppStorage("measurementSystem") var measurementSystem: Int = 1
    @State var isSheetShowing = false
    @State private var exerciseNames = UserDefaults.standard.array(forKey: "exerciseNames") as? [String] ?? [String]()
    @State private var newExerciseName = ""
    
    var body : some View {
        NavigationView {
            Form {
                List {
                    Section {
                        Picker("Measurement System", selection: $measurementSystem) {
                            Text("Metric").tag(0)
                            Text("US").tag(1)
                        }
                    } header: {
                        Text("Localization")
                    } 
                    Section {
                        NavigationLink("Exercises") {
                            List {
                                ForEach (exerciseNames, id: \.self) { name in
                                    Text(name)
                                }
                                //.onDelete { exerciseNames.remove(atOffsets: $0) }
                            }
                            .toolbar {
                                ToolbarItemGroup(placement: .topBarTrailing) {
                                    Button(action: { isSheetShowing = true; UserDefaults.standard.set(exerciseNames, forKey: "exerciseNames") }) {
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
                                                    Button("Done", action: { addExercise(name: newExerciseName) })
                                                        .disabled(newExerciseName.count == 0)
                                                }
                                            }
                                        }
                                    }
                                }
                                ToolbarItemGroup(placement: .topBarTrailing) {
                                    EditButton()
                                }
                            }
                        }
                    }
                    Section {
                        Button("Reset", role: .destructive, action: {
                            do {
                                try context.delete(model: Workout.self)
                                dismiss()
                            } catch {
                                print(error.localizedDescription)
                            }
                        })
                    } footer: {
                        Text("Workouts 0.0.1")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: { dismiss() })
                }
                ToolbarItem(placement: .principal) {
                    Text("Settings").font(.headline)
                }
            }
        }
    }
    func addExercise(name: String) {
        exerciseNames.append(name)
        UserDefaults.standard.set(exerciseNames, forKey: "exerciseNames")
        isSheetShowing = false
    }
}
