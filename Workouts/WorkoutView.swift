//
//  WorkoutView.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//

import SwiftUI

struct WorkoutView: View {
    var title: String
    
    @State private var isShowingSheet = false
    @State private var newName = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var exercises: FetchedResults<Exercise>
    
    var body: some View {
        List {
            ForEach(exercises) { exercise in
                Section {
                    Text(exercise.name)
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: { isShowingSheet = true }) {
                    Label("Add Item", systemImage: "plus")
                }
                .sheet(isPresented: $isShowingSheet, onDismiss: addWorkout) {
                    Form {
                        TextField("Name", text: $newName)
                    }
                }
            }
        }
    }
    
    private func addWorkout() {
        withAnimation {
            let newExercise = Exercise(context: viewContext)
            newExercise.name = newName
            
            newName = ""

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteWorkouts(offsets: IndexSet) {
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
    }
}
