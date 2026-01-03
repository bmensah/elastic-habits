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
    @StateObject private var dailyContextStore = DailyContextStore()
    @StateObject var dailyLogStore = DailyLogStore()
    
    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environmentObject(habitStore)
                .environmentObject(dailyContextStore)
                .environmentObject(dailyLogStore)
        }
    }
}
