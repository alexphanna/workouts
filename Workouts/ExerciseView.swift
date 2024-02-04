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
    @State private var newReps: String = ""
    @State private var newWeight: String = ""
    @State var exercise: Exercise
    
    var body: some View {
        NavigationLink(destination: InfoView(title: exercise.description, sets: exercise.sets)) {
            Text(exercise.description)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        }
        .disabled(editMode?.wrappedValue.isEditing == true || exercise.sets.count == 0)
        if (exercise.sets.count > 0) {
            if (editMode?.wrappedValue.isEditing == true) {
                ForEach(exercise.sets.sorted { $0.date < $1.date }, id: \.self) { set in
                    Text(set.description)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                .onDelete { exercise.sets.remove(atOffsets: $0) }
            }
            else {
                VStack {
                    ForEach(exercise.sets.sorted { $0.date < $1.date }, id: \.self) { set in
                        Text(set.description)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        }
        if (editMode?.wrappedValue.isEditing == true) {
            Button("Add Set", action: { isSheetShowing = true })
                .deleteDisabled(true)
                .sheet(isPresented: $isSheetShowing) {
                NavigationView {
                    Form {
                        HStack {
                            Text("Reps")
                            TextField("0", text: $newReps).multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        HStack {
                            Text("Weight")
                            TextField("0", text: $newWeight).multilineTextAlignment(.trailing)
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
                                .disabled(Int(newReps) ?? 0 == 0 && Int(newWeight) ?? 0 == 0)
                        }
                    }
                }
            }
        }
    }
    func addSet() {
        exercise.sets.append(Set(reps: Int(newReps) ?? 0, weight: Int(newWeight) ?? 0))
        isSheetShowing = false
    }
}
