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
    @State private var newReps: Int = 0
    @State private var newWeight: Int = 0
    @State var exercise: Exercise
    
    var body: some View {
        Text(exercise.name)
        if (exercise.sets.count > 0) {
            if (editMode?.wrappedValue.isEditing == true) {
                ForEach(0..<exercise.sets.count, id: \.self) { i in
                    Text(exercise.sets[i].description)
                }
                .onDelete { exercise.sets.remove(atOffsets: $0) }
                .onMove { exercise.sets.move(fromOffsets: $0, toOffset: $1) }
            }
            else {
                VStack {
                    ForEach(0..<exercise.sets.count, id: \.self) { i in
                        Text(exercise.sets[i].description)
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
                            Stepper(newReps.description, value: $newReps).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Weight: ")
                            TextField("", value: $newWeight, formatter: NumberFormatter()).multilineTextAlignment(.trailing)
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
        if (newReps > 0) {
            exercise.sets.append(Set(reps: newReps, weight: newWeight))
            isSheetShowing = false
            newReps = 0
            newWeight = 0
        }
    }
}
