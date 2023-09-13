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
    struct Set {
        var reps : Int
        var weight : Int
    }
}

struct ExerciseView: View {
    var exercise : Exercise
    init(name : String) {
        exercise = Exercise(name: name)
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(exercise.name)
                        .font(.headline)
                }
                Spacer()
                Button(action: temp) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
    func temp() {
        
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseView(name: "Bench Press")
    }
}
