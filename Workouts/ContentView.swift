//
//  ContentView.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftUI

struct ContentView: View {
    @State  private var workouts: [Workout] = [Workout(name: "Push", date: .now)]
    @State private var isSheetShowing = false
    @State private var newWorkoutName = ""
    @State private var newWorkoutDate: Date = .now
    
    var body: some View {
        NavigationView {
            List {
                ForEach(workouts) { workout in
                    NavigationLink(destination: WorkoutView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                            Text(workout.date.formatted(date: .numeric, time: .omitted))
                                .font(.callout)
                        }
                    }
                }
                .onDelete { workouts.remove(atOffsets: $0) }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: { isSheetShowing = true }) {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $isSheetShowing) {
                        NavigationView {
                            Form {
                                HStack {
                                    Text("Name")
                                    TextField("push", text: $newWorkoutName).multilineTextAlignment(.trailing)
                                }
                                DatePicker("Date", selection: $newWorkoutDate, displayedComponents: [.date])
                            }
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancel", action: { isSheetShowing = false })
                                }
                                ToolbarItem(placement: .principal) {
                                    Text("Add Workout").font(.headline)
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button("Done", action: { addWorkout() }).disabled(newWorkoutName.count == 0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addWorkout() {
        if (newWorkoutName.count > 0) {
            workouts.append(Workout(name: newWorkoutName, date: newWorkoutDate))
            workouts = workouts.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
            isSheetShowing = false
            newWorkoutName = ""
            newWorkoutDate = .now
        }
    }
}

#Preview {
    ContentView()
}
