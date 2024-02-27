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
    @State private var isShowingDialog = false
    @State private var newName: String = ""
    @State private var newDate: Date = .now
    
    @State private var isEditing: EditMode = .inactive
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)])
    private var workouts: FetchedResults<Workout>
    
    @State private var multiSelection = Swift.Set<Workout>()

    var body: some View {
        NavigationView {
            List(selection: $multiSelection) {
                ForEach(workouts, id: \.self) { workout in
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.headline)
                        Text(workout.date.formatted(.dateTime.month(.defaultDigits).day(.defaultDigits).year(.twoDigits)))
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                    .contextMenu {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deleteWorkout(workout: workout)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deleteWorkout(workout: workout)
                        }
                    }
                    .background {
                        NavigationLink(destination: WorkoutView(workout: workout)) { }
                            .opacity(0)
                    }
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                if isEditing == .inactive {
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
                else if isEditing == .active {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        if multiSelection.count == 0 {
                            Button("Delete All", action: { isShowingDialog = true } )
                                .confirmationDialog("", isPresented: $isShowingDialog) {
                                    Button("Delete All", role: .destructive, action: { deleteAllWorkouts() })
                                }
                        }
                        else {
                            Button("Delete", action: { deleteWorkouts(workouts: multiSelection)} )
                        }
                    }
                }
            }
            .environment(\.editMode, $isEditing)
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
            
            multiSelection = Swift.Set<Workout>()
        }
    }
    
    private func deleteWorkout(workout: Workout) {
        withAnimation {
            viewContext.delete(workout)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            multiSelection = Swift.Set<Workout>()
        }
    }

    private func deleteWorkouts(workouts: Swift.Set<Workout>) {
        withAnimation {
            workouts.map { $0 }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            multiSelection = Swift.Set<Workout>()
        }
    }
    
    private func deleteAllWorkouts() {
        withAnimation {
            for workout in workouts {
                viewContext.delete(workout)
            }
            
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
