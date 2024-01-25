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
    
    var body : some View {
        NavigationView {
            Form {
                List {
                    Section {
                        Picker("Measurement System", selection: $measurementSystem) {
                            Text("Metric").tag(0)
                            Text("US").tag(1)
                        }
                        Button("Reset", role: .destructive, action: {
                            do {
                                try context.delete(model: Workout.self)
                                dismiss()
                            } catch {
                                print(error.localizedDescription)
                            }
                        })
                    } header: {
                        Text("Localization")
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
}
