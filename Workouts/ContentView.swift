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
                    NavigationLink(destination: WorkoutView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .bold()
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
                    .sheet(isPresented: $isShowingSheet) {
                        NavigationView {
                            Form {
                                TextField("Name", text: $newName)
                                DatePicker("Date", selection: $newDate, displayedComponents: [.date])
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
                                    Button("Done", action: addWorkout )
                                        .disabled(newName.isEmpty)
                                }
                            }
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
            
            isShowingSheet = false
            newDate = Date.now
            newName = ""

            do {
                try viewContext.save()
            } catch {
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
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
