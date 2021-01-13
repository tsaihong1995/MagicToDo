//
//  MagicToDoApp.swift
//  MagicToDo
//
//  Created by Hung-Chun Tsai on 2021-01-11.
//

import SwiftUI

@main
struct MagicToDoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TasksView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
