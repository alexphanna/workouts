//
//  Exercise.swift
//  Workouts
//
//  Created by Alex Hanna on 9/13/23.
//

import SwiftUI

struct Exercise {
    var name : String
    var sets : [Set] = []
    struct Set : Hashable {
        var reps : Int
        var weight : Int
    }
}

struct ExerciseView: View {
    var exercise : Exercise
    init(name : String) {
        exercise = Exercise(name: name)
        exercise.sets.append(Set(reps: 8, weight: 100))
    }
    var body: some View {
        Section {
            Text(exercise.name)
                .font(.headline)
            List(exercise.sets, id: \.self) { set in
                Text(String(set.reps))
            }
        }
    }
    func temp() {
        
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
