//
//  Simple_WordlistApp.swift
//  Simple Wordlist
//
//  Created by Raven Jiang on 6/7/24.
//

import SwiftUI

@main
struct Simple_WordlistApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
