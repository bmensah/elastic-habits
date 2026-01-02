//
//  ContentView.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//
//  NOTE: This view is a temporary demo used to validate core logic.
//  It will be replaced once full CRUD and navigation are added.
//
//  MARK: - Demo Data
//  MARK: - State
//  MARK: - Computered Properties
//  MARK: - View


import SwiftUI

private func tierLabel(_ tier: Tier) -> String {
    switch tier {
    case .A: return "A"
    case .B: return "B"
    case .C: return "C"
    }
}

struct ContentView: View {
    @EnvironmentObject var habitStore: HabitStore
    
    @State private var selectedHabitIndex = 0
    @State private var context = DailyContext.default
    @State private var selectedTier = Tier.B
    
    private var currentHabit: Habit? {
        guard !habitStore.habits.isEmpty, selectedHabitIndex < habitStore.habits.count else {
            return nil
        }
        return habitStore.habits[selectedHabitIndex]
    }
    
    private var requiredTier: Tier {
        guard let habit = currentHabit else { return .A }
        return RuleEngine.requiredTier(habit: habit, context: context)
    }
    
    private var isCompliant: Bool {
        selectedTier.rawValue >= requiredTier.rawValue
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let habit = currentHabit {
                Text(habit.name)
                    .font(.title)
                
                Picker("Habit", selection: $selectedHabitIndex) {
                    ForEach(Array(habitStore.habits.enumerated()), id: \.element.id) { index, habit in
                        Text(habit.name).tag(index)
                    }
                }
                .pickerStyle(.segmented)

                Toggle("Low Energy", isOn: Binding(
                    get: { context.lowEnergy },
                    set: { context = DailyContext(lowEnergy: $0, workedLate: context.workedLate) }
                ))
                
                Toggle("Worked Late", isOn: Binding(
                    get: { context.workedLate },
                    set: { context = DailyContext(lowEnergy: context.lowEnergy, workedLate: $0) }
                ))
                
                Picker("Tier", selection: $selectedTier) {
                    Text("A").tag(Tier.A)
                    Text("B").tag(Tier.B)
                    Text("C").tag(Tier.C)
                }
                Text("Selected: \(tierLabel(selectedTier))")
                Text("Required: \(tierLabel(requiredTier))")
                .pickerStyle(.segmented)
                
                Text(isCompliant ? "Counts as success" : "Below minimum")
                    .font(.headline)
            } else {
                Text("No habits available")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .onChange(of: habitStore.habits.count) { oldCount, newCount in
            if selectedHabitIndex >= newCount && newCount > 0 {
                selectedHabitIndex = newCount - 1
            } else if newCount == 0 {
                selectedHabitIndex = 0
            }
        }
    }
}
