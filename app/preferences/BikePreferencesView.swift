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
        NavigationStack {
            VStack {
                switch currentStep {
                case .type:
                    BikeTypeView(preferences: $preferences, onNext: {
                        onNext()
                    })
                case .electric:
                    BikeElectricView(preferences: $preferences, onNext: {
                        onNext()
                    })
                case .priceRange:
                    BikePriceRangeView(preferences: $preferences) {
                        onSearch()
                    }
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
            }
            .navigationTitle(currentStep.title)
        }
    }
    
    func onNext() {
        if let nextStep = currentStep.nextStep {
            currentStep = nextStep
        }
    }
    
    func onSearch() {
        // TODO send search to api, on response show search tab with updated results
    }
}

struct BikeTypeView: View {
    @Binding var preferences: BikePreferences
    var onNext: () -> Void

    var body: some View {
        VStack {
            Button("Road")
            {
                preferences.type = .road
//                onNext()
            }
            .preferenceButton()
            Button("Mountain") {
                preferences.type = .mountain
//                onNext()
            }
            .preferenceButton()
            Button("Hybrid") {
                preferences.type = .hybrid
//                onNext()
            }
            .preferenceButton()
            Button("Folding") {
                preferences.type = .folding
//                onNext()
            }
            .preferenceButton()
        }
    }
}

extension Button {
    func preferenceButton() -> some View {
        foregroundColor(Color.gray)
            .font(.system(size: 30))
            .padding(.bottom, 10)
    }
}

struct BikeElectricView: View {
    @Binding var preferences: BikePreferences
    var onNext: () -> Void

    var body: some View {
        VStack {
            Button("Yes") {
                preferences.electric = true
//                onNext()
            }
            .preferenceButton()
            Button("No") {
                preferences.electric = false
//                onNext()
            }
            .preferenceButton()
        }
    }
}

struct BikePriceRangeView: View {
    @Binding var preferences: BikePreferences
    var onSearch: () -> Void

    var body: some View {
        VStack {
            Text("Price range")
            Button("< 500") {
                preferences.price_min = "0"
                preferences.price_max = "499"
            }
            .preferenceButton()
            Button("500 - 1000") {
                preferences.price_min = "500"
                preferences.price_max = "1000"
            }
            .preferenceButton()
            Button("1000 - 2000") {
                preferences.price_min = "1000"
                preferences.price_max = "2000"
            }
            .preferenceButton()
            Button("< 2000") {
                preferences.price_min = "2000"
                preferences.price_max = "100000"
            }
            .preferenceButton()
            Button("Search!") {
                onSearch()
            }
        }
    }
}
