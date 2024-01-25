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
    @State var name: String
    @State var reps: [Int]
    @State var weights: [Int]
    
    var body: some View {
        Text(name)
            if (reps.count > 0) {
            if (editMode?.wrappedValue.isEditing == true) {
                ForEach(0..<reps.count, id: \.self) { i in
                    Text(reps[i].description + " x " + weights[i].description + " lbs")
                }
                //.onDelete { exercise.sets.remove(atOffsets: $0) }
                //.onMove { exercise.sets.move(fromOffsets: $0, toOffset: $1) }
            }
            else {
                VStack {
                    ForEach(0..<reps.count, id: \.self) { i in
                        Text(reps[i].description + " x " + weights[i].description + " lbs")
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
                            TextField("0", value: $newWeight, formatter: NumberFormatter()).multilineTextAlignment(.trailing)
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
            reps.append(newReps)
            weights.append(newWeight)
            isSheetShowing = false
            newReps = 0
            newWeight = 0
        }
    }
}
