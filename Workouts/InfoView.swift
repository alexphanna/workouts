//
//  InfoView.swift
//  Workouts
//
//  Created by Alex on 2/3/24.
//

import SwiftUI
import SwiftData

struct InfoView: View {
    @State var exercise: Exercise
    @State var unit: String = UserDefaults.standard.string(forKey: "measurementSystem") ?? ""
    @Query(sort: \Workout.date, order: .reverse) var workouts: [Workout]
    
    var body: some View {
        List {
            Section {
                LabeledContent("Average reps", value: (((averageReps() * 10).rounded()) / 10).description)
                LabeledContent("Average weight", value: (((averageWeight() * 10).rounded()) / 10).description + " " + unit)
                LabeledContent("Training volume", value: volume().description + " " + unit)
                
            } header: {
                Text("Current Statistics")
            }
            Section {
                LabeledContent("One-rep max", value: oneRepMax().description + " " + unit)
                LabeledContent("Personal record", value: personalRecord().description)
                
            } header: {
                Text("All-Time Statistics")
            }
            Section {
                TextEditor(text: $exercise.notes)
                    .font(.callout)
            } header: {
                Text("Notes")
            }
        }
        .navigationTitle(exercise.description)
    }
    
    func averageReps() -> Double {
        var sum = 0
        var count = 0
        for set in exercise.sets {
            if (!set.warmup) {
                sum += set.reps
                count += 1
            }
        }
        return Double(sum) / Double(count)
    }
    func averageWeight() -> Double {
        var totalReps = 0
        var sum = 0
        for set in exercise.sets {
            if (!set.warmup) {
                totalReps += set.reps
                sum += set.volume
            }
        }
        return Double(sum) / Double(totalReps)
    }
    func volume() -> Int {
        var volume = 0
        for set in exercise.sets {
            volume += set.volume
        }
        return volume
    }
    func oneRepMax() -> Int {
        var max = 0
        for workout in workouts {
            for exercise in workout.exercises {
                if exercise.description == self.exercise.description {
                    for set in exercise.sets {
                        if set.weight > max {
                            max = set.weight
                        }
                    }
                }
            }
        }
        return max
    }
    func personalRecord() -> Set {
        var maxVolume = 0
        var maxSet = Set(reps: 0, weight: 0)
        for workout in workouts {
            for exercise in workout.exercises {
                if exercise.description == self.exercise.description {
                    for set in exercise.sets {
                        if set.volume > maxVolume {
                            maxVolume = set.volume
                            maxSet = set
                        }
                    }
                }
            }
        }
        return maxSet
    }
}
