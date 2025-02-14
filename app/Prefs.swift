import Foundation

struct Prefs {
    private static let itemPrefsKey = "itemPreferences"
    private static let lastSwipedDate = "lastSwipedDate"

    static func saveItemPrefs(_ prefs: ItemPreferences) throws {
        let store = NSUbiquitousKeyValueStore.default

        if let data = try? JSONEncoder().encode(prefs) {
            store.set(data, forKey: itemPrefsKey)
            store.synchronize()
        }
    }
    
    static func loadItemPrefs() throws -> ItemPreferences? {
        let store = NSUbiquitousKeyValueStore.default

        if let data = store.data(forKey: itemPrefsKey),
            let decodedObject = try? JSONDecoder().decode(ItemPreferences.self, from: data) {
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
    
    static func clearLastSwipedTimestamp() throws {
        let store = NSUbiquitousKeyValueStore.default
        store.removeObject(forKey: lastSwipedDate)
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
