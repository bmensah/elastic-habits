//
//  HabitDetailView.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import SwiftUI

private func tierLabel(_ tier: Tier) -> String {
    switch tier {
    case .A: return "A"
    case .B: return "B"
    case .C: return "C"
    }
}

struct HabitDetailView: View {
    let habitId: UUID
    @EnvironmentObject var habitStore: HabitStore
    
    @State private var context = DailyContext.default
    @State private var selectedTier = Tier.A
    
    private var habit: Habit? {
        habitStore.habits.first { $0.id == habitId }
    }
    
    private var requiredTier: Tier {
        return RuleEngine.requiredTier(context: context)
    }
    
    private var isCompliant: Bool {
        selectedTier.rawValue >= requiredTier.rawValue
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let habit = habit {
                Text(habit.name)
                    .font(.title)
                
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
                .pickerStyle(.segmented)
                Text("Selected: \(tierLabel(selectedTier))")
                Text("Required: \(tierLabel(requiredTier))")
                
                Text(isCompliant ? "Counts as success" : "Below minimum")
                    .font(.headline)
            } else {
                Text("Habit not found")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

