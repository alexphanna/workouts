//
//  WorkoutView.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//

import SwiftUI

struct WorkoutView: View {
    @State private var isShowingSheet = false
    @State private var newName = ""
    @State var workout: Workout
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        List {
            ForEach(workout.exercises.array as? [Exercise] ?? []) { (exercise: Exercise) in
                Section {
                    ExerciseView(exercise: exercise)
                }
            }
        }
        .navigationTitle(workout.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: { isShowingSheet = true }) {
                    Label("Add Item", systemImage: "plus")
                }
                .sheet(isPresented: $isShowingSheet) {
                    NavigationView {
                        Form {
                            TextField("Name", text: $newName)
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
                                Button("Done", action: addExercise )
                                    .disabled(newName.isEmpty)
                            }
                        }
                    }
                }
            }
        }
    }
    private func addExercise() {
        let newExercise = Exercise(context: viewContext)
        newExercise.name = newName
        
        workout.addToExercises(newExercise)
        
        isShowingSheet = false
        newName = ""
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    /*private func deleteExercises(offsets: IndexSet) {
        withAnimation {
            offsets.map { exercises[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }*/
}
