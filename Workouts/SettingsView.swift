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
    @AppStorage("limitExercises") var limitExercises: Bool = true
    @State var isSheetShowing = false
    @State var confirmationShow = false
    @State private var exerciseNames = UserDefaults.standard.array(forKey: "exerciseNames") as? [String] ?? [String]()
    @State private var equipmentNames = UserDefaults.standard.array(forKey: "equipmentNames") as? [String] ?? [String]()
    @State private var newExerciseName = ""
    @State private var newEquipmentName = ""
    
    var body : some View {
        NavigationView {
            Form {
                List {
                    Section {
                        Toggle(isOn: $limitExercises) {
                            Text("Limit exercises")
                        }
                        if (limitExercises) {
                            NavigationLink("Exercises") {
                                List {
                                    ForEach (exerciseNames, id: \.self) { name in
                                        Text(name)
                                    }
                                    .onDelete { removeName(names: &exerciseNames, at: $0, forKey: "exerciseNames") }
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
                                                        Button("Done", action: { addName(names: &exerciseNames, name: newExerciseName, forKey: "exerciseNames") })
                                                            .disabled(newExerciseName.count == 0)
                                                    }
                                                }
                                            }
                                        }
                                        EditButton()
                                    }
                                }
                            }
                        }
                        Section {
                            NavigationLink("Equipment") {
                                List {
                                    ForEach (equipmentNames, id: \.self) { name in
                                        Text(name)
                                    }
                                    .onDelete { removeName(names: &equipmentNames, at: $0, forKey: "equipmentNames") }
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .topBarTrailing) {
                                        Button(action: { isSheetShowing = true; UserDefaults.standard.set(equipmentNames, forKey: "equipmentNames") }) {
                                            Image(systemName: "plus")
                                        }.sheet(isPresented: $isSheetShowing) {
                                            NavigationView {
                                                Form {
                                                    TextField("Name", text: $newEquipmentName)
                                                }
                                                .toolbar {
                                                    ToolbarItem(placement: .cancellationAction) {
                                                        Button("Cancel", action: { isSheetShowing = false })
                                                    }
                                                    ToolbarItem(placement: .principal) {
                                                        Text("Add Exercise").font(.headline)
                                                    }
                                                    ToolbarItem(placement: .confirmationAction) {
                                                        Button("Done", action: { addName(names: &equipmentNames, name: newEquipmentName, forKey: "equipmentNames") })
                                                            .disabled(newEquipmentName.count == 0)
                                                    }
                                                }
                                            }
                                        }
                                        EditButton()
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Personalization")
                    }
                    Section {
                        Picker("Measurement System", selection: $measurementSystem) {
                            Text("Metric").tag(0)
                            Text("US").tag(1)
                        }
                    } header: {
                        Text("Localization")
                    }
                    Section {
                        Button("Reset", role: .destructive, action: { confirmationShow = true })
                            .confirmationDialog("This will reset your workouts.", isPresented: $confirmationShow, titleVisibility: .visible) {
                            Button("Reset Workouts", role: .destructive, action: {
                                if let bundleID = Bundle.main.bundleIdentifier {
                                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                                }
                                do {
                                    try context.delete(model: Workout.self)
                                    confirmationShow = false
                                } catch {
                                    print(error.localizedDescription)
                                }
                            })
                        }
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
    func addName(names: inout [String], name: String, forKey: String) {
        names.append(name)
        UserDefaults.standard.set(names, forKey: forKey)
        isSheetShowing = false
    }
    func removeName(names: inout [String], at offsets: IndexSet, forKey: String) {
        names.remove(atOffsets: offsets)
        UserDefaults.standard.set(names, forKey: forKey)
    }
}
