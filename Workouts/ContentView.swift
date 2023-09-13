//
//  ContentView.swift
//  Workouts
//
//  Created by Alex Hanna on 9/13/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                List {
                    ExerciseView(name: "Squat")
                    ExerciseView(name: "Deadlift")
                }
            }
            .tabItem {
                Image(systemName: "plus")
            }
        }
    }
    func addSet() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
