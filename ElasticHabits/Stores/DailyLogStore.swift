import Foundation
import Combine

// MARK: - DailyLogStore
// Tracks the user's logged tier for each habit with persistence
@MainActor
final class DailyLogStore: ObservableObject {
    
    // MARK: - Published State
    // Maps habit ID to logged tier. nil means "not logged"
    @Published var loggedTiers: [UUID: Tier?] = [:] {
        didSet { save() }
    }
    
    // MARK: - Init
    init() {
        load()
    }
    
    // MARK: - Public API
    func logTier(_ tier: Tier?, for habitId: UUID) {
        loggedTiers[habitId] = tier
    }
    
    func getLoggedTier(for habitId: UUID) -> Tier? {
        return loggedTiers[habitId] ?? nil
    }
    
    func isLogged(for habitId: UUID) -> Bool {
        return loggedTiers[habitId] != nil
    }
    
    // MARK: - Persistence
    private func fileURL() throws -> URL {
        let documents = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        return documents.appendingPathComponent("today_logs.json")
    }
    
    private func load() {
        do {
            let url = try fileURL()
            guard FileManager.default.fileExists(atPath: url.path) else {
                loggedTiers = [:]
                return
            }
            
            let data = try Data(contentsOf: url)
            // Decode as [String: Int?] since UUID keys need to be strings in JSON
            let decoded = try JSONDecoder().decode([String: Int?].self, from: data)
            
            // Convert back to [UUID: Tier?]
            loggedTiers = decoded.compactMapKeys { UUID(uuidString: $0) }
                .mapValues { intValue in
                    if let int = intValue {
                        return Tier(rawValue: int)
                    }
                    return nil
                }
        } catch {
            // If anything goes wrong, fall back to empty dictionary
            loggedTiers = [:]
        }
    }
    
    private func save() {
        do {
            let url = try fileURL()
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            // Convert [UUID: Tier?] to [String: Int?] for JSON encoding
            let jsonDict = loggedTiers.mapKeys { $0.uuidString }
                .mapValues { tier in
                    tier?.rawValue
                }
            
            let data = try encoder.encode(jsonDict)
            try data.write(to: url, options: [.atomic])
        } catch {
            // Intentionally ignore save errors for MVP
        }
    }
}

// MARK: - Dictionary Extension
extension Dictionary {
    func mapKeys<T>(_ transform: (Key) throws -> T) rethrows -> [T: Value] {
        return try Dictionary<T, Value>(uniqueKeysWithValues: map { (try transform($0.key), $0.value) })
    }
    
    func compactMapKeys<T>(_ transform: (Key) throws -> T?) rethrows -> [T: Value] {
        return try Dictionary<T, Value>(uniqueKeysWithValues: compactMap { key, value in
            guard let newKey = try transform(key) else { return nil }
            return (newKey, value)
        })
    }
}

