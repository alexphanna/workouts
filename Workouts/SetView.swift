//
//  SetView.swift
//  Workouts
//
//  Created by Alex on 1/21/24.
//

import SwiftUI

struct SetView: View {
    @State var set: Set
    var body: some View {
        if (set.weight != 0) {
            if (UserDefaults.standard.integer(forKey: "measurementSystem") == 0) {
                Text(set.reps.description + " x " + set.weight.description + "kgs")
            }
            else {
                Text(set.reps.description + " x " + set.weight.description + "lbs")
            }
        }
        else {
            Text(set.reps.description)
        }
    }
}
