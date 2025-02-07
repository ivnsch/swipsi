import SwiftUI

struct BikePreferences {
    var type: BikeType = .road
    var electric: Bool = false
    var price_min: String = "0"
    var price_max: String = "100000"
}

enum BikeType {
    case road, mountain, hybrid, folding
}

enum BikePreferenceStep {
    case type, electric, priceRange
    
    var title: String {
        switch self {
            case .type: return "Type"
            case .electric: return "Electric"
            case .priceRange: return "Price Range"
        }
    }
    
    var previousStep: BikePreferenceStep? {
        switch self {
        case .type: return nil
        case .electric: return .type
        case .priceRange: return .electric
        }
    }
    
    var nextStep: BikePreferenceStep? {
        switch self {
        case .type: return .electric
        case .electric: return .priceRange
        case .priceRange: return nil
        }
    }
}

struct BikePreferencesView: View {
    @State private var preferences = BikePreferences()
    @State private var currentStep: BikePreferenceStep = .type
    
    var body: some View {
        VStack {
            switch currentStep {
            case .type:
                BikeTypeView(preferences: $preferences)
            case .electric:
                BikeElectricView(preferences: $preferences)
            case .priceRange:
                BikePriceRangeView(preferences: $preferences)
            }
            
            HStack {
                if let previousStep = currentStep.previousStep {
                    Button("Previous") {
                        currentStep = previousStep
                    }
                }
                
                if let nextStep = currentStep.nextStep {
                    Button("Next") {
                        currentStep = nextStep
                    }
                }
            }
        }.navigationTitle(currentStep.title)
    }
}

struct BikeTypeView: View {
    @Binding var preferences: BikePreferences

    var body: some View {
        VStack {
            Text("Type")
            Button("Road") {
                preferences.type = .road
            }
            Button("Mountain") {
                preferences.type = .mountain
            }
            Button("Hybrid") {
                preferences.type = .hybrid
            }
            Button("Folding") {
                preferences.type = .folding
            }
        }
    }
}

struct BikeElectricView: View {
    @Binding var preferences: BikePreferences

    var body: some View {
        VStack {
            Text("Electric?")
            Button("Yes") {
                preferences.electric = true
            }
            Button("No") {
                preferences.electric = false
            }
        }
    }
}

struct BikePriceRangeView: View {
    @Binding var preferences: BikePreferences

    var body: some View {
        VStack {
            Text("Price range")
            Button("< 500") {
                preferences.price_min = "0"
                preferences.price_max = "499"
            }
            Button("500 - 1000") {
                preferences.price_min = "500"
                preferences.price_max = "1000"
            }
            Button("1000 - 2000") {
                preferences.price_min = "1000"
                preferences.price_max = "2000"
            }
            Button("< 2000") {
                preferences.price_min = "2000"
                preferences.price_max = "100000"
            }
        }
    }
}
