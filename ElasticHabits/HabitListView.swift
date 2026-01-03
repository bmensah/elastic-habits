//
//  HabitListView.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitStore: HabitStore
    @EnvironmentObject var dailyContextStore: DailyContextStore
    @EnvironmentObject var dailyLogStore: DailyLogStore
    @State private var showingAddHabit = false
    
    private func statusForHabit(_ habit: Habit) -> String {
        let loggedTier = dailyLogStore.getLoggedTier(for: habit.id)
        
        guard let selectedTier = loggedTier else {
            return "Not logged"
        }
        
        let requiredTier = RuleEngine.requiredTier(context: dailyContextStore.context)
        let isCompliant = selectedTier.rawValue >= requiredTier.rawValue
        
        return isCompliant ? "Counts as success" : "Below minimum"
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Low Energy", isOn: Binding(
                        get: { dailyContextStore.context.lowEnergy },
                        set: { dailyContextStore.context = DailyContext(lowEnergy: $0, workedLate: dailyContextStore.context.workedLate) }
                    ))
                    
                    Toggle("Worked Late", isOn: Binding(
                        get: { dailyContextStore.context.workedLate },
                        set: { dailyContextStore.context = DailyContext(lowEnergy: dailyContextStore.context.lowEnergy, workedLate: $0) }
                    ))
                }
                
                Section {
                    ForEach(habitStore.habits) { habit in
                        NavigationLink(value: habit.id) {
                            HStack {
                                Text(habit.name)
                                Spacer()
                                Text(statusForHabit(habit))
                                    .foregroundColor(.secondary)
                            }
                        }
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

