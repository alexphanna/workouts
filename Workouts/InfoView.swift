//
//  InfoView.swift
//  Workouts
//
//  Created by Alex on 2/3/24.
//

import SwiftUI

struct InfoView: View {
    @State var title: String
    @State var sets: [Set]
    @State var unit: String = UserDefaults.standard.string(forKey: "measurementSystem") ?? ""
    
    var body: some View {
        List {
            Section {
                LabeledContent("Average reps", value: (((average(index: 0) * 10).rounded()) / 10).description + " " + unit)
                LabeledContent("Average weight", value: (((average(index: 1) * 10).rounded()) / 10).description + " " + unit)
            } header: {
                Text("Statistics")
            }
        }
        .navigationTitle(title)
    }
    func average(index: Int) -> Double {
        var sum = 0
        for set in sets {
            if index == 0 {
                sum += set.reps
            }
            else if index == 1 {
                sum += set.weight
            }
        }
        return Double(sum) / Double(sets.count)
    }
}
