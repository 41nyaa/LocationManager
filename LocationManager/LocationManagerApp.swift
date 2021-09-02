//
//  LocationManagerApp.swift
//  LocationManager
//
//  Created by scho on 2021/09/01.
//

import SwiftUI

@main
struct LocationManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(LocationService())
        }
    }
}
