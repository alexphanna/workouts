//
//  ContentView.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isShowingSheet = false
    @State private var newName: String = ""
    @State private var newDate: Date = .now
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)],
        animation: .default)
    private var workouts: FetchedResults<Workout>

    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(destination: WorkoutView(title: workout.name)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                            Text((workout.date.formatted(date: .numeric, time: .omitted)))
                        }
                    }
                }
                .onDelete(perform: deleteWorkouts)
            }
            .navigationTitle("Workouts")
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
                            DatePicker("Date", selection: $newDate, displayedComponents: [.date])
                        }
                    }
                }
            }
        }
    }

    private func addWorkout() {
        withAnimation {
            let newWorkout = Workout(context: viewContext)
            newWorkout.date = newDate
            newWorkout.name = newName
            newWorkout.exercises = []
            
            newDate = Date.now
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
            offsets.map { workouts[$0] }.forEach(viewContext.delete)

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

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
