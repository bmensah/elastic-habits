import Foundation
import Combine

// MARK: - DailyContextStore
// Tracks the user's selected daily context with persistence
@MainActor
final class DailyContextStore: ObservableObject {
    
    // MARK: - Published State
    @Published var context: DailyContext = .default {
        didSet { save() }
    }
    
    // MARK: - Init
    init() {
        load()
    }
    
    // MARK: - Persistence
    private func fileURL() throws -> URL {
        let documents = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return documents.appendingPathComponent("daily_context.json")
    }
    
    private func load() {
        do {
            let url = try fileURL()
            guard FileManager.default.fileExists(atPath: url.path) else {
                context = .default
                return
            }
            
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(DailyContext.self, from: data)
            context = decoded
        } catch {
            // If anything goes wrong, fall back to default context
            context = .default
        }
    }
    
    private func save() {
        do {
            let url = try fileURL()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(context)
            try data.write(to: url, options: [.atomic])
        } catch {
            // Intentionally ignore save errors for MVP
        }
    }
}

