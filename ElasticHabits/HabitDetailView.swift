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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitStore: HabitStore
    @EnvironmentObject var dailyContextStore: DailyContextStore
    @EnvironmentObject var dailyLogStore: DailyLogStore
    
    @State private var selectedTier: Tier? = nil
    @State private var showingEditHabit = false
    
    private var habit: Habit? {
        habitStore.habits.first { $0.id == habitId }
    }
    
    private var requiredTier: Tier {
        return RuleEngine.requiredTier(context: dailyContextStore.context)
    }
    
    private var selectedTierLabel: String {
        if let tier = selectedTier {
            return tierLabel(tier)
        }
        return "Not logged"
    }
    
    private var isCompliant: Bool {
        guard let selectedTier = selectedTier else { return false }
        return selectedTier.rawValue >= requiredTier.rawValue
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let habit = habit {
                Text(habit.name)
                    .font(.title)
                
                Picker("Tier", selection: $selectedTier) {
                    Text("Not logged").tag(nil as Tier?)
                    Text("A").tag(Tier.A as Tier?)
                    Text("B").tag(Tier.B as Tier?)
                    Text("C").tag(Tier.C as Tier?)
                }
                .pickerStyle(.segmented)
                Text("Selected: \(selectedTierLabel)")
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
        .onAppear {
            // Load previously logged tier from DailyLogStore
            selectedTier = dailyLogStore.getLoggedTier(for: habitId)
        }
        .onChange(of: selectedTier) { oldValue, newValue in
            // Save tier selection to DailyLogStore immediately when changed
            dailyLogStore.logTier(newValue, for: habitId)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingEditHabit = true
                } label: {
                    Text("Edit")
                }
                .disabled(habit == nil)
            }
        }
        .sheet(isPresented: $showingEditHabit) {
            if let habit = habit {
                HabitEditView(habit: habit) {
                    dismiss()
                }
            }
        }
    }
}

