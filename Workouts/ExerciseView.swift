//
//  ExerciseView.swift
//  Workouts
//
//  Created by Alex on 2/7/24.
//

import SwiftUI

struct ExerciseView: View {
    @State private var isShowingSetSheet = false
    @State private var isShowingExerciseSheet = false
    @State private var newReps = ""
    @State private var newWeight = ""
    @State private var newName = ""
    @State private var newEquipment = ""
    @State private var isActive = false
    @State private var isDeleted = false
    @State var exercise: Exercise
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        if !isDeleted {
            HStack {
                // Weird workaround to refresh exercise description after renaming
                Text(isShowingExerciseSheet ? exercise.description.capitalized : exercise.description.capitalized)
                    .bold()
                Spacer()
                Menu {
                    Button(action: { isShowingSetSheet = true }) {
                        Label("Add Set", systemImage: "plus")
                    }
                    Button(action: { isActive = true }) {
                        Label("Show Exercise Info", systemImage: "info.circle")
                    }
                    Button(action: {
                        newName = exercise.name
                        newEquipment = exercise.equipment
                        isShowingExerciseSheet = true
                    }) {
                        Label("Rename", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: { deleteExericse() }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(editMode?.wrappedValue.isEditing == true ? .gray : .blue)
                        .imageScale(.large)
                }
                .disabled(editMode?.wrappedValue.isEditing == true)
            }
            .sheet(isPresented: $isShowingSetSheet) {
                NavigationView {
                    Form {
                        TextField("Reps", text: $newReps)
                            .keyboardType(.numberPad)
                        TextField("Weight", text: $newWeight)
                            .keyboardType(.decimalPad)
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: { isShowingSetSheet = false })
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
            .sheet(isPresented: $isShowingExerciseSheet) {
                NavigationView {
                    Form {
                        if UserDefaults.standard.bool(forKey: "limitExercises") {
                            Picker("Name", selection: $newName) {
                                ForEach(UserDefaults.standard.array(forKey: "defaultExercises") as? [String] ?? [String](), id: \.self) { exercise in
                                    Text(exercise)
                                }
                            }
                        }
                        else {
                            TextField("Name", text: $newName)
                        }
                        Picker("Equipment", selection: $newEquipment) {
                            ForEach(["Barbell", "Dumbbell", "Kettlebell", "Machine", "None"], id: \.self) { equipment in
                                Text(equipment)
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", action: { isShowingExerciseSheet = false })
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Rename Workout")
                                .font(.headline)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done", action: renameExericse )
                        }
                    }
                }
            }
            .background(
                NavigationLink(destination: StatsView(exercise: exercise), isActive: $isActive) {
                    EmptyView()
                }
                    .opacity(0)
                    .onTapGesture {
                        isActive = false
                    }
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
        }
    }
    
    private func addSet() {
        withAnimation {
            let newSet = Set(context: viewContext)
            newSet.reps = Int16(newReps) ?? 0
            newSet.weight = Float(newWeight) ?? 0
            
            exercise.addToSets(newSet)
            
            isShowingSetSheet = false
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
    
    private func deleteExericse() {
        withAnimation {
            isDeleted = true
            viewContext.delete(exercise)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func renameExericse() {
        withAnimation {
            exercise.name = newName
            exercise.equipment = newEquipment
            
            isShowingExerciseSheet = false

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
