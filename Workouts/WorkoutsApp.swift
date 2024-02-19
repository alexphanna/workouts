//
//  WorkoutsApp.swift
//  Workouts
//
//  Created by Alex on 2/6/24.
//

import SwiftUI

@main
struct WorkoutsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
