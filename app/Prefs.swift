import Foundation

struct Prefs {
    private static let bikePrefsKey = "bikePreferences"
    private static let lastSwipedDate = "lastSwipedDate"

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
    
    static func saveLastSwipedTimestamp(_ timestamp: UInt64) throws {
        let store = NSUbiquitousKeyValueStore.default
        store.set(NSNumber(value: timestamp), forKey: lastSwipedDate)
        store.synchronize()
    }
    
    static func loadLastSwipedTimestamp() throws -> UInt64? {
        let store = NSUbiquitousKeyValueStore.default
        if let number = store.object(forKey: lastSwipedDate) as? NSNumber {
            let loadedValue = number.uint64Value
            return loadedValue
        } else {
            return nil
        }
    }
}
