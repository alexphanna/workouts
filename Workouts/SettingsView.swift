//
//  SettingsView.swift
//  Workouts
//
//  Created by Alex on 2/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("limitExercises") private var limitExercises: Bool = false
    @AppStorage("unit") private var unit: String = "lb"
    @AppStorage("estimation") private var estimation: String = "Epley"
    @State private var defaultExercises = UserDefaults.standard.stringArray(forKey: "defaultExercises")
    @State private var defaultEquipment = UserDefaults.standard.stringArray(forKey: "defaultEquipment")
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $limitExercises) {
                        Text("Limit Exercises")
                    }
                    if UserDefaults.standard.bool(forKey: "limitExercises") {
                        NavigationLink("Exercises") {
                            DefaultsView(defaults: defaultExercises, forKey: "defaultExercises")
                        }
                    }
                    NavigationLink("Equipment") {
                        DefaultsView(defaults: defaultEquipment, forKey: "defaultEquipment")
                    }
                    Picker(selection: $estimation, label: Text("1RM Estimation")) {
                        Text("Epley").tag("Epley")
                        Text("Brzycki").tag("Brzycki")
                    }
                }
                Picker(selection: $unit, label: Text("Weight Unit")) {
                    Text("Pound (lb)").tag("lb")
                    Text("Kilogram (kg)").tag("kg")
                }
                .pickerStyle(.inline)
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.headline)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: { dismiss() } )
                }
            }
        }
    }
    
    private struct DefaultsView: View {
        @State var defaults: [String]?
        @State var forKey: String
        @State private var isShowingSheet: Bool = false
        @State private var newName: String = ""
        
        var body: some View {
            List {
                ForEach(defaults ?? [String](), id: \.self) { item in
                    Text(item)
                }
                .onDelete(perform: removeItem)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    Button(action: { isShowingSheet = true }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $isShowingSheet) {
                        NavigationView {
                            Form {
                                TextField("Name", text: $newName)
                            }
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel", action: { isShowingSheet = false} )
                                    }
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Done", action: addItem )
                                    }
                                }
                        }
                    }
                }
            }
        }
        private func addItem() {
            isShowingSheet = false
            defaults?.append(newName)
            UserDefaults.standard.set(defaults, forKey: forKey)
        }
        private func removeItem(at offsets: IndexSet) {
            defaults?.remove(atOffsets: offsets)
            UserDefaults.standard.set(defaults, forKey: forKey)
        }
    }
}
