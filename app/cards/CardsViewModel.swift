//
//  CardsViewModel.swift
//  app
//
//  Created by Ivan Schuetz on 07.02.25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class CardsViewModel: ObservableObject {
    @Published var cardModels: [Item] = []
    
    var modelContext: ModelContext?

    private let api: Api
    
    private var lastItemPrefs: ItemPreferences? = nil
    
    init(api: Api) {
        self.api = api
    }
    
    func tryFetchCardModelsInOnAppear() {
        do {
            if try checkPreferencesAndShouldLoadInOnAppear() {
                try loadInOnAppear()
            }
            
        } catch {
            print("error retrieving lastSwipedTimestamp: \(error)")
        }
    }
    

    // returns true if we should load items from api, false otherwise
    func checkPreferencesAndShouldLoadInOnAppear() throws -> Bool {
        // load new items either the first onAppear or when prefs were changed between onAppears
        let prefs = try Prefs.loadItemPrefs()
        if let lastItemPrefs = lastItemPrefs {
            if lastItemPrefs == prefs {
                // not first load (lastItemPrefs is not null) and no preferences change: no reason to load
                return false;
            } else {
                // this is a bit clunky but ~acceptable for now,
                // when changing preferences,
                // the last swiped time becomes invalid against the new items
                // (we've e.g. possibly not seen any items under a new category, a timestamp in the future would return no items)
                // (remember that timestamps are just from where items were added to database, which is kind of arbitrary between different categories/price buckets etc)
                // so we've to clear last swiped time in order to get all items for the new settings
                // note that the user might have seen these items if they had enabled the same settings further in the past
                // but that's a ux problem we're ok with for now
                try Prefs.clearLastSwipedTimestamp()
            }
        }
        
        lastItemPrefs = prefs
        return true
    }
    
    func loadInOnAppear() throws {
        // we start after the last card that was swiped, or from beginning (0 timestamp) if user hasn't swiped yet
        let lastSwipedTimestamp = try Prefs.loadLastSwipedTimestamp() ?? 0
//            let lastSwipedTimestamp: UInt64 = 0 // debug
        startFetchCardModels(afterTimestamp: lastSwipedTimestamp)
    }
    
    func startFetchCardModels(afterTimestamp: UInt64) {
        Task { await fetchCardModels(afterTimestamp: afterTimestamp) }
    }
    
    func setModelContext(_ modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchCardModels(afterTimestamp: UInt64) async {
        do {
            let prefs = try Prefs.loadItemPrefs()
            let apiFilters = toApiFilters(prefs)
            let items = try await api.getItems(afterTimestamp: afterTimestamp, filters: apiFilters)
            self.cardModels = items
        } catch {
            print("Failed to fetch cards with error: \(error)")
        }
    }
    
    // if preferences is nil this just adds all the types, meaning we accept everything
    func toApiFilters(_ prefs: ItemPreferences?) -> Filters {
        var types: [String] = []
        if prefs?.necklace ?? true {
            types.append("necklace")
        }
        if prefs?.bracelet ?? true {
            types.append("armband")
        }
        if prefs?.ring ?? true {
            types.append("ring")
        }
        if prefs?.earring ?? true {
            types.append("earring")
        }
       
        var prices: [Int] = []
        if prefs?.price_1 ?? true {
            prices.append(1)
        }
        if prefs?.price_2 ?? true {
            prices.append(2)
        }
        if prefs?.price_3 ?? true {
            prices.append(3)
        }
        if prefs?.price_4 ?? true {
            prices.append(4)
        }

        return Filters(type_: types, price: prices)
    }
    
    // if the user hasn't stored any prefs yet, we don't filter, i.e. accept everything
    func nonFilteredPrefs() -> ItemPreferences {
        return ItemPreferences(necklace: true, bracelet: true, ring: true, earring: true,
                               price_1: true, price_2: true, price_3: true, price_4: true)
    }
    
    
    func dislike(_ item: Item) {
        dontShowAgain(item)
        do {
            try saveTimestamp(item)
        } catch {
            print("Error saving timestamp: \(error)")
        }
        removeCard(item)
    }
    
    func like(_ item: Item) {
        dontShowAgain(item)
        do {
            try saveTimestamp(item)
        } catch {
            // TODO error handling
            print("Error saving timestamp: \(error)")
        }
        do {
            try saveLike(item)
        } catch {
            // TODO error handling
            print("Error saving like: \(error)")
        }
        removeCard(item)

    }
    
    func saveTimestamp(_ item: Item) throws {
        try Prefs.saveLastSwipedTimestamp(item.addedTimestamp)
    }
    
    private func dontShowAgain(_ item: Item) {
        // TODO
        // probably add to a json list of ids that's sent to the server each time
        // or if we don't want the server to do filtering (bad e.g. for caching) filter the response with this list in the client
    }
    
    private func removeCard(_ item: Item) {
        guard let index = cardModels.firstIndex(where: { $0.id == item.id }) else { return }
        cardModels.remove(at: index)
        
        // if there are n cards left, fetch the next batch
        // note that we don't need any conditions for "stop fetching batches":
        // when the server doesn't send new items, nothing is added, so if user continues swiping
        // the "n cards left" condition doesn't happen again
        if cardModels.count == 10 {
            if let lastItem = cardModels.last {
                startFetchCardModels(afterTimestamp: lastItem.addedTimestamp)
            } else {
                print("Invalid state: we just checked that there are 10 cardModels, should have `last`")
            }
        }
    }
    
    private func saveLike(_ item: Item) throws {
        guard let modelContext = modelContext else {
            print("Invalid state: model context not set")
            return
        }
        
        // normally this shouldn't happen as already swiped cards shouldn't be presented again
        // but maybe we're not considering edge cases
        guard try !isItemAlreadyLiked(modelContext: modelContext, item: item) else {
            print("Invalid state: trying to add on already liked object (by id) to likes")
            return
        }
        
        let currentCount = cardModels.count

        // for now we'll assume that there's no repetition,
        // an item with the same id as an already liked one would not be shown again and thus ux should not allow to like twice
        let like = LikedItem(
            id: item.id,
            name: item.name,
            price: item.price,
            priceCurrency: item.priceCurrency,
            pictures: item.pictures,
            likedDate: Date(),
            vendorLink: item.vendorLink,
            type: item.type,
            descr: item.descr,
            order: currentCount
        )
        modelContext.insert(like)
        
        do {
            try modelContext.save()
        } catch {
            // TODO error handling
            print("error saving: \(error)")
        }
    }
    
    func isItemAlreadyLiked(modelContext: ModelContext, item: Item) throws -> Bool {
        let itemId = item.id  // Capture the value
        let descriptor = FetchDescriptor<LikedItem>(
            predicate: #Predicate { $0.id == itemId }
        )
        let likedItemsForId = try modelContext.fetch(descriptor)
        return !likedItemsForId.isEmpty
    }
}
