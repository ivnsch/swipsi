import SwiftUI

struct BikePreferences {
    var mountain: Bool = false
    var road: Bool = false
    var hybrid: Bool = false
    var electric: Bool = false
    var nonElectric: Bool = false
    var price_1: Bool = false
    var price_2: Bool = false
    var price_3: Bool = false
    var price_4: Bool = false
}


enum BikeType {
    case road, mountain, hybrid
}

enum BikePreferenceStep {
    case type, electric, priceRange
    
    var title: String {
        switch self {
            case .type: return "Type"
            case .electric: return "Electric?"
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
                    BikeTypeView(preferences: $preferences)
                case .electric:
                    BikeElectricView(preferences: $preferences)
                case .priceRange:
                    BikePriceRangeView(preferences: $preferences)
                }
                
                HStack {
                    if let previousStep = currentStep.previousStep {
                        BorderedButton("Previous") {
                            currentStep = previousStep
                        }
                    }
                    if let nextStep = currentStep.nextStep {
                        BorderedButton("Next") {
                            currentStep = nextStep
                        }
                    } else {
                        BorderedButton("Search") {
                            onSearch()
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

struct BorderedButton: View {
    let label: String
    let action: () -> Void
    
    init(_ label: String, action: @escaping () -> Void) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .padding(10)
                .foregroundColor(.blue)
                .background(
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                    .stroke(.blue, lineWidth: 2)

                )
        }
    }
}

struct BikeTypeView: View {
    @Binding var preferences: BikePreferences

    var body: some View {
        VStack {
            Button("Road")
            {
                preferences.road = !preferences.road
            }
            .preferenceButton(selected: preferences.road)
            Button("Mountain") {
                preferences.mountain = !preferences.mountain
            }
            .preferenceButton(selected: preferences.mountain)
            Button("Hybrid") {
                preferences.hybrid = !preferences.hybrid
            }
            .preferenceButton(selected: preferences.hybrid)
        }
    }
}

extension Button {
    func preferenceButton(selected: Bool) -> some View {
        foregroundColor(selected ? Color.black : Color.gray)
            .font(.system(size: 30))
            .padding(.bottom, 10)
    }
}

struct BikeElectricView: View {
    @Binding var preferences: BikePreferences

    var body: some View {
        VStack {
            Button("Yes") {
                preferences.electric = !preferences.electric
                preferences.nonElectric = !preferences.electric
            }
            .preferenceButton(selected: preferences.electric)
            Button("No") {
                preferences.nonElectric = !preferences.nonElectric
                preferences.electric = !preferences.nonElectric
            }
            .preferenceButton(selected: preferences.nonElectric)
            Button("Both") {
                preferences.electric = true
                preferences.nonElectric = true
            }
            .preferenceButton(selected: preferences.electric && preferences.nonElectric)
        }
    }
}

struct BikePriceRangeView: View {
    @Binding var preferences: BikePreferences

    var body: some View {
        VStack {
            Button("€") {
                preferences.price_1 = !preferences.price_1
            }
            .preferenceButton(selected: preferences.price_1)
            Button("€€") {
                preferences.price_2 = !preferences.price_2
            }
            .preferenceButton(selected: preferences.price_2)
            Button("€€€") {
                preferences.price_3 = !preferences.price_3
            }
            .preferenceButton(selected: preferences.price_3)
            Button("€€€€") {
                preferences.price_4 = !preferences.price_4
            }
            .preferenceButton(selected: preferences.price_4)
        }
    }
}
