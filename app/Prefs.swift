import Foundation

struct Prefs {
    private static let bikePrefsKey = "bikePreferences"
    
    static func saveBikePrefs(_ prefs: BikePreferences) throws {
        let store = NSUbiquitousKeyValueStore.default

        if let data = try? JSONEncoder().encode(prefs) {
            store.set(data, forKey: bikePrefsKey)
            store.synchronize()
        }
    }
    
    static func loadBikePrefs() throws -> BikePreferences? {
        let store = NSUbiquitousKeyValueStore.default

        if let data = store.data(forKey: bikePrefsKey),
            let decodedObject = try? JSONDecoder().decode(BikePreferences.self, from: data) {
            return decodedObject
        } else {
            return nil
        }
    }
}
