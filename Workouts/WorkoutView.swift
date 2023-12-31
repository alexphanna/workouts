//
//  WorkoutView.swift
//  Workouts
//
//  Created by Alex on 12/31/23.
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Text("Bench press")
                            .bold()
                        Text("8 x 115\n8 x 115")
                        Button(action: addItem) {
                            Label("Add Set", systemImage: "plus")
                        }
                    }
                    Section {
                        Button(action: addItem) {
                            Label("Add Exercise", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Push")
            .toolbar { EditButton() }
        }
    }
}

func addItem() {
    
}
