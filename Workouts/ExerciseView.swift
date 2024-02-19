//
//  ExerciseView.swift
//  Workouts
//
//  Created by Alex on 2/7/24.
//

import SwiftUI

struct ExerciseView: View {
    @State private var isShowingSheet = false
    @State private var newReps = ""
    @State private var newWeight = ""
    @State var exercise: Exercise
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        Text(exercise.name)
            .bold()
        if exercise.sets.count > 0 {
            VStack(alignment: .leading) {
                ForEach(exercise.sets.array as? [Set] ?? []) { set in
                    Text(set.description)
                }
            }
        }
        if editMode?.wrappedValue.isEditing == true {
            Button("Add Set", action: { isShowingSheet = true })
                .sheet(isPresented: $isShowingSheet) {
                    NavigationView {
                        Form {
                            TextField("Reps", text: $newReps)
                            TextField("Weight", text: $newWeight)
                        }
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", action: { isShowingSheet = false })
                            }
                            ToolbarItem(placement: .principal) {
                                Text("Add Exercise")
                                    .font(.headline)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done", action: addSet )
                                    .disabled(newReps.isEmpty || newWeight.isEmpty)
                            }
                        }
                    }
                }
        }
    }
    
    private func addSet() {
        withAnimation {
            let newSet = Set(context: viewContext)
            newSet.reps = Int16(newReps) ?? 0
            newSet.weight = Int16(newWeight) ?? 0
            
            exercise.addToSets(newSet)
            
            isShowingSheet = false
            newReps = ""
            newWeight = ""

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
