//
//  InfoView.swift
//  Workouts
//
//  Created by Alex on 2/3/24.
//

import SwiftUI

struct InfoView: View {
    @State var exercise: Exercise
    @State var unit: String = UserDefaults.standard.string(forKey: "measurementSystem") ?? ""
    
    var body: some View {
        List {
            Section {
                ZStack(alignment: .leading) {
                    TextEditor(text: $exercise.notes)
                        .font(.callout)
                }
            } header: {
                Text("Notes")
            }
            Section {
                LabeledContent("Average reps", value: (((average(index: 0) * 10).rounded()) / 10).description + " " + unit)
                LabeledContent("Average weight", value: (((average(index: 1) * 10).rounded()) / 10).description + " " + unit)
                LabeledContent("Training volume", value: volume().description + " " + unit)
            } header: {
                Text("Statistics")
            }
        }
        .navigationTitle(exercise.name)
    }
    func average(index: Int) -> Double {
        var sum = 0
        for set in exercise.sets {
            if index == 0 {
                sum += set.reps
            }
            else if index == 1 {
                sum += set.weight
            }
        }
        return Double(sum) / Double(exercise.sets.count)
    }
    func volume() -> Int {
        var volume = 0
        for set in exercise.sets {
            volume += set.reps * set.weight
        }
        return volume
    }
}
