//
//  ExerciseView.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftUI

struct ExerciseView: View {
    @State var exercise: Exercise
    @State private var isSheetShowing = false
    @State private var reps: Int = 0
    @State private var weight: Int?
    
    var body: some View {
        Text(exercise.name)
        Button("Add Set", action: { isSheetShowing = true })
            .sheet(isPresented: $isSheetShowing) {
            NavigationView {
                Form {
                    HStack {
                        Text("Reps: ")
                        Stepper(reps.description, value: $reps).multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Weight")
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
                        Button("Done", action: { })
                            .disabled(reps == 0)
                    }
                }
            }
        }
    }
}
