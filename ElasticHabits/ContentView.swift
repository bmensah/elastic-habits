//
//  ContentView.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//
//  Day 1 Demo View
//  Purpose: Prove rule-based required tier logic works in a live SwiftUI view.
//  This view is intentionally hardcoded and will be replaced once persistence is added.
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
    let habits = [
        Habit(
            id: UUID(),
            name: "Exercise",
            tierA: "30 min workout",
            tierB: "15 min walk", 
            tierC: "5 min stretch",
            rules: [
                Rule(id: UUID(), condition: .workedLate, allowedTier: .C),
                Rule(id: UUID(), condition: .lowEnergy, allowedTier: .B)
            ]
        ),
        Habit(
            id: UUID(),
            name: "Reading",
            tierA: "30 min reading",
            tierB: "15 min reading",
            tierC: "5 min reading",
            rules: [
                Rule(id: UUID(), condition: .workedLate, allowedTier: .B),
                Rule(id: UUID(), condition: .lowEnergy, allowedTier: .C)
            ]
        )
    ]
    
    @State private var selectedHabitIndex = 0
    @State private var context = DailyContext.default
    @State private var selectedTier = Tier.B
    
    private var currentHabit: Habit {
        habits[selectedHabitIndex]
    }
    
    private var requiredTier: Tier {
        RuleEngine.requiredTier(habit: currentHabit, context: context)
    }
    
    private var isCompliant: Bool {
        selectedTier.rawValue >= requiredTier.rawValue
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(currentHabit.name)
                .font(.title)
            
            Picker("Habit", selection: $selectedHabitIndex) {
                Text("Exercise").tag(0)
                Text("Reading").tag(1)
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
        }
        .padding()
    }
}
