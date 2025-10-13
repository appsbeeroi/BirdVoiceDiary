import Foundation

final class UDManager {
    
    static let shared = UDManager()
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func set<T: Codable>(_ value: T, for key: UDKeys) async {
        do {
            let data = try encoder.encode(value)
            defaults.set(data, forKey: key.rawValue)
        } catch {
            print("⚠️ Failed to encode \(T.self): \(error.localizedDescription)")
        }
    }
    
    func get<T: Codable>(_ type: T.Type, for key: UDKeys) async -> T? {
        guard let data = defaults.data(forKey: key.rawValue) else { return nil }
        
        do {
            return try decoder.decode(type, from: data)
        } catch {
            print("⚠️ Failed to decode \(T.self): \(error.localizedDescription)")
            return nil
        }
    }
    
    func remove(_ key: UDKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}

enum UDKeys: String {
    case observation
}
