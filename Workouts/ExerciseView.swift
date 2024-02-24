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
        HStack {
            if editMode?.wrappedValue.isEditing == true {
                Text(exercise.description.capitalized)
                    .bold()
                    .foregroundStyle(.gray)
            }
            else {
                Text(exercise.description.capitalized)
                    .bold()
            }
            Spacer()
            Image(systemName: "info.circle")
                .foregroundColor(.blue)
                .imageScale(.large)
        }
        .background(
            NavigationLink("", destination: StatsView(exercise: exercise))
                .opacity(0)
        )
        .disabled(editMode?.wrappedValue.isEditing == true)
        if exercise.sets.count > 0 {
            if editMode?.wrappedValue.isEditing == true {
                ForEach(exercise.sets.array as? [Set] ?? []) { set in
                    Text(set.description)
                }
                .onDelete(perform: deleteSet)
            }
            else {
                VStack(alignment: .leading) {
                    ForEach(exercise.sets.array as? [Set] ?? []) { set in
                        Text(set.description)
                    }
                }
                .deleteDisabled(true)
            }
        }
        if editMode?.wrappedValue.isEditing == true {
            Button("Add Set", action: { isShowingSheet = true })
                .sheet(isPresented: $isShowingSheet) {
                    NavigationView {
                        Form {
                            TextField("Reps", text: $newReps)
                                .keyboardType(.numberPad)
                            TextField("Weight", text: $newWeight)
                                .keyboardType(.decimalPad)
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
                .deleteDisabled(true)
        }
    }
    
    private func addSet() {
        withAnimation {
            let newSet = Set(context: viewContext)
            newSet.reps = Int16(newReps) ?? 0
            newSet.weight = Float(newWeight) ?? 0
            
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
    
    func deleteSet(offsets: IndexSet) {
        withAnimation {
            if let sets = exercise.sets.array as? [Set] {
                offsets.map { sets[$0] }.forEach(viewContext.delete)
                
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
}

private struct StatsView: View {
    @ObservedObject var exercise: Exercise
    @State var notes: String = ""
    @AppStorage("unit") private var unit: String = "lbs"
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.date, ascending: false)])
    private var workouts: FetchedResults<Workout>
    
    var body: some View {
        List {
            if exercise.sets.count > 0 {
                Section(header: Text("Current")) {
                    LabeledContent("Average reps", value: (((exercise.averageReps * 10).rounded()) / 10).description)
                    LabeledContent("Average weights", value: (((exercise.averageWeights * 10).rounded()) / 10).description + " " + unit)
                    LabeledContent("Training volume", value: exercise.volume.description + " " + unit)
                }
            }
            if exerciseExists() {
                Section(header: Text("All-time")) {
                    LabeledContent("Personal record", value: personalRecord()?.description ?? "")
                    LabeledContent("One-rep max", value: oneRepMax().description + " " + unit)
                }
            }
            Section(header: Text("Notes")) {
                TextEditor(text: $exercise.notes)
                    .font(.callout)
            }
        }
        .navigationTitle(exercise.description)
    }
    
    private func exerciseExists() -> Bool {
        for workout in workouts {
            for exercise in workout.exercises.array as? [Exercise] ?? [Exercise]() {
                if exercise.name == self.exercise.name && exercise.sets.count > 0 {
                    return true
                }
            }
        }
        return false
    }
    
    private func personalRecord() -> Set? {
        var maxSet: Set? = nil
        for workout in workouts {
            for exercise in workout.exercises.array as? [Exercise] ?? [Exercise]() {
                if exercise.name == self.exercise.name {
                    for set in exercise.sets.array as? [Set] ?? [Set]() {
                        if set.volume > maxSet?.volume ?? 0 {
                            maxSet = set
                        }
                    }
                }
            }
        }
        return maxSet
    }
    
    private func oneRepMax() -> Float {
        var maxWeight: Float = 0
        for workout in workouts {
            for exercise in workout.exercises.array as? [Exercise] ?? [Exercise]() {
                if exercise.name == self.exercise.name {
                    for set in exercise.sets.array as? [Set] ?? [Set]() {
                        if set.weight > maxWeight {
                            maxWeight = set.weight
                        }
                    }
                }
            }
        }
        return maxWeight
    }
}
