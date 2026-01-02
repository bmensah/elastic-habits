//
//  ElasticHabitsApp.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import SwiftUI

@main
struct ElasticHabitsApp: App {
    @StateObject private var habitStore = HabitStore()
    
    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environmentObject(habitStore)
        }
    }
}
