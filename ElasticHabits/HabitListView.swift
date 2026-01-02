//
//  HabitListView.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var showingAddHabit = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(habitStore.habits) { habit in
                    NavigationLink(value: habit.id) {
                        Text(habit.name)
                    }
                }
            }
            .navigationDestination(for: UUID.self) { habitId in
                HabitDetailView(habitId: habitId)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                HabitEditView(habit: nil)
            }
        }
    }
}

