import Foundation
import Combine

// MARK: - HabitStore
// Day 2 milestone:
// - Single source of truth for habits
// - Local-only JSON persistence (Documents/habits.json)
// - Seeds sample habits on first launch
@MainActor
final class HabitStore: ObservableObject {

    // MARK: - Published State
    @Published var habits: [Habit] = [] {
        didSet { save() }
    }

    // MARK: - Init
    init() {
        loadOrSeed()
    }

    // MARK: - Public API
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    func updateHabit(_ habit: Habit) {
        guard let idx = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[idx] = habit
    }

    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
    }

    // MARK: - Persistence
    private func fileURL() throws -> URL {
        let documents = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return documents.appendingPathComponent("habits.json")
    }

    private func loadOrSeed() {
        do {
            let url = try fileURL()
            guard FileManager.default.fileExists(atPath: url.path) else {
                habits = Self.sampleHabits()
                return
            }

            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Habit].self, from: data)
            habits = decoded
        } catch {
            // If anything goes wrong, fall back to sample data so the app remains usable.
            habits = Self.sampleHabits()
        }
    }

    private func save() {
        do {
            let url = try fileURL()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(habits)
            try data.write(to: url, options: [.atomic])
        } catch {
            // Intentionally ignore save errors for MVP.
            // (You could surface this in a debug banner later.)
        }
    }

    // MARK: - Sample Data
    private static func sampleHabits() -> [Habit] {
        [
            Habit(
                id: UUID(),
                name: "Exercise",
                tierA: "30 min workout",
                tierB: "15 min walk",
                tierC: "5 min stretch"
            ),
            Habit(
                id: UUID(),
                name: "Reading",
                tierA: "30 min reading",
                tierB: "10 min reading",
                tierC: "Read 1 page"
            )
        ]
    }
}
