//
//  ExerciseView.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftData
import SwiftUI

struct ExerciseView: View {
    @Environment(\.editMode) private var editMode
    @State private var isSheetShowing = false
    @State private var reps: Int = 0
    @State private var weight: Int = 0
    @State var exercise: Exercise
    
    var body: some View {
        Text(exercise.name)
        if (exercise.sets.count > 0) {
            if (editMode?.wrappedValue.isEditing == true) {
                ForEach(exercise.sets) { set in
                    SetView(set: set)
                }
                .onDelete { exercise.sets.remove(atOffsets: $0) }
                .onMove { exercise.sets.move(fromOffsets: $0, toOffset: $1) }
            }
            else {
                VStack {
                    ForEach(exercise.sets) { set in
                        SetView(set: set)
                    }
                }
            }
        }
        if (editMode?.wrappedValue.isEditing == true) {
            Button("Add Set", action: { isSheetShowing = true })
                .sheet(isPresented: $isSheetShowing) {
                NavigationView {
                    Form {
                        HStack {
                            Text("Reps: ")
                            Stepper(reps.description, value: $reps).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Weight: ")
                            TextField("0", value: $weight, formatter: NumberFormatter()).multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: { isSheetShowing = false })
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Add Set").font(.headline)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done", action: { addSet() })
                        }
                    }
                }
            }
        }
    }
    func addSet() {
        if (reps > 0) {
            exercise.sets.append(Set(reps: reps, weight: weight))
            isSheetShowing = false
            reps = 0
            weight = 0
        }
    }
}
