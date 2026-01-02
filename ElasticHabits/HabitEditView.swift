//
//  HabitEditView.swift
//  ElasticHabits
//
//  Created by Bradley Mensah on 12/18/25.
//

import SwiftUI

struct HabitEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var habitStore: HabitStore
    
    let habit: Habit?
    var onDelete: (() -> Void)? = nil
    
    @State private var name: String = ""
    @State private var tierA: String = ""
    @State private var tierB: String = ""
    @State private var tierC: String = ""
    @State private var showingDeleteConfirmation = false
    
    private var isEditing: Bool {
        habit != nil
    }
    
    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespaces)
    }
    
    private var hasDuplicateName: Bool {
        let lowercasedName = trimmedName.lowercased()
        guard !lowercasedName.isEmpty else { return false }
        
        return habitStore.habits.contains { existingHabit in
            // When editing, exclude the current habit from the duplicate check
            if let currentHabit = habit, existingHabit.id == currentHabit.id {
                return false
            }
            return existingHabit.name.lowercased() == lowercasedName
        }
    }
    
    private var isValid: Bool {
        !trimmedName.isEmpty &&
        !tierA.trimmingCharacters(in: .whitespaces).isEmpty &&
        !tierB.trimmingCharacters(in: .whitespaces).isEmpty &&
        !tierC.trimmingCharacters(in: .whitespaces).isEmpty &&
        !hasDuplicateName
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    if hasDuplicateName {
                        Text("An existing habit with this name already exists")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    TextField("Tier A", text: $tierA)
                    TextField("Tier B", text: $tierB)
                    TextField("Tier C", text: $tierC)
                }
                
                if isEditing {
                    Section {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Delete Habit")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Habit" : "New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            if let habit = habit {
                name = habit.name
                tierA = habit.tierA
                tierB = habit.tierB
                tierC = habit.tierC
            }
        }
        .alert("Delete Habit", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteHabit()
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
    
    private func deleteHabit() {
        guard let habit = habit else { return }
        
        // Delete the habit from the store
        // This will automatically persist due to HabitStore's didSet
        habitStore.deleteHabit(habit)
        
        // Call onDelete callback if provided (e.g., to dismiss parent view)
        onDelete?()
        
        // Dismiss the sheet
        dismiss()
    }
    
    private func saveHabit() {
        let trimmedTierA = tierA.trimmingCharacters(in: .whitespaces)
        let trimmedTierB = tierB.trimmingCharacters(in: .whitespaces)
        let trimmedTierC = tierC.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty,
              !trimmedTierA.isEmpty,
              !trimmedTierB.isEmpty,
              !trimmedTierC.isEmpty,
              !hasDuplicateName else {
            return
        }
        
        if let existingHabit = habit {
            let updatedHabit = Habit(
                id: existingHabit.id,
                name: trimmedName,
                tierA: trimmedTierA,
                tierB: trimmedTierB,
                tierC: trimmedTierC
            )
            habitStore.updateHabit(updatedHabit)
        } else {
            let newHabit = Habit(
                id: UUID(),
                name: trimmedName,
                tierA: trimmedTierA,
                tierB: trimmedTierB,
                tierC: trimmedTierC
            )
            habitStore.addHabit(newHabit)
        }
        
        dismiss()
    }
}

