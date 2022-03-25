//
//  CeresApp.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import SwiftUI

@main
struct CeresApp: App {
    @State private var selection: Tab = .workouts
    
    enum Tab {
        case workouts
    }
    
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
//        WindowGroup {
//            TabView(selection: $selection) {
//                NavigationView() {
//                    WorkoutsView()
//                }
//                .navigationViewStyle(.stack)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .tabItem {
//                    Label("Workouts", systemImage: "list.bullet")
//                }
//                .tag(Tab.workouts)
//            }
//        }
        WindowGroup {
            TabView(selection: $selection) {
                NavigationView() {
                    WorkoutListView()
                }
                .navigationViewStyle(.stack)
                .tabItem {
                    Label("Workouts", systemImage: "list.bullet")
                }
                .tag(Tab.workouts)
            }
        }
    }
}
