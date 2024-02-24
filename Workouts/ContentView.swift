//
//  ContentView.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    @State private var isShowingSheet = false
    @State private var isShowingSettingsSheet = false
    @State private var newName: String = ""
    @State private var newDate: Date = .now
    
    @Environment(\.editMode) private var editMode
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)])
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
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { isShowingSettingsSheet = true } ) {
                        Image(systemName: "gear")
                    }.sheet(isPresented: $isShowingSettingsSheet) {
                        SettingsView()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: { isShowingSheet = true }) {
                        Image(systemName: "plus")
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
                ToolbarItem(placement: .status) {
                    if workouts.count == 0 {
                        Text("No Workouts")
                            .font(.caption)
                    }
                    else if workouts.count == 1 {
                        Text(workouts.count.description + " Workout")
                            .font(.caption)
                    }
                    else {
                        Text(workouts.count.description + " Workouts")
                            .font(.caption)
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
