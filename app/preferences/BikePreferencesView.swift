import SwiftUI
import SwiftData

struct BikePreferences: Codable {
    var mountain: Bool = false
    var road: Bool = false
    var hybrid: Bool = false
    var electric: Bool = false
    var nonElectric: Bool = false
    var price_1: Bool = false
    var price_2: Bool = false
    var price_3: Bool = false
    var price_4: Bool = false
    
    init(mountain: Bool, road: Bool, hybrid: Bool, electric: Bool, nonElectric: Bool, price_1: Bool, price_2: Bool, price_3: Bool, price_4: Bool) {
        self.mountain = mountain
        self.road = road
        self.hybrid = hybrid
        self.electric = electric
        self.nonElectric = nonElectric
        self.price_1 = price_1
        self.price_2 = price_2
        self.price_3 = price_3
        self.price_4 = price_4
    }
}

enum ValidationError {
    case atLeastOneSelected
}

enum BikeType: Decodable, Hashable {
    case road, mountain, hybrid
}

enum BikePreferenceStep {
    case type, electric, priceRange, summary
    
    var title: String {
        switch self {
            case .type: return "Type"
            case .electric: return "Electric?"
            case .priceRange: return "Price Range"
            case .summary: return "Summary"
        }
    }
    
    var previousStep: BikePreferenceStep? {
        switch self {
        case .type: return nil
        case .electric: return .type
        case .priceRange: return .electric
        case .summary: return .priceRange
        }
    }
    
    var nextStep: BikePreferenceStep? {
        switch self {
        case .type: return .electric
        case .electric: return .priceRange
        case .priceRange: return .summary
        case .summary: return nil

        }
    }
}

struct BikePreferencesView: View {
    @State private var preferences = BikePreferences(mountain: false, road: false, hybrid: false, electric: false,
                                                     nonElectric: false, price_1: false, price_2: false, price_3: false, price_4: false)
    @State private var currentStep: BikePreferenceStep = .type
    
    @Environment(\.modelContext) private var modelContext

    @State private var validationError: ValidationError?
    
    var body: some View {
        NavigationStack {
            VStack {
                if let v = validationError {
                    Text(validationMessage(v))
                        .padding(.bottom, 20)
                        .foregroundColor(.red)
                }
                switch currentStep {
                case .type:
                    BikeTypeView(preferences: $preferences)
                case .electric:
                    BikeElectricView(preferences: $preferences)
                case .priceRange:
                    BikePriceRangeView(preferences: $preferences)
                case .summary:
                    BikePreferencesSummaryView(preferences: preferences)
                }
                HStack {
                    if let previousStep = currentStep.previousStep {
                        BorderedButton("Previous") {
                            currentStep = previousStep
                            self.validationError = nil
                        }
                        .opacity(0.5)
                    }
                    if let nextStep = currentStep.nextStep {
                        BorderedButton("Next") {
                            if let error = validate(currentStep: currentStep, preferences: preferences) {
                                self.validationError = error
                            } else {
                                currentStep = nextStep
                                self.validationError = nil
                            }
                        }
                    } else {
                        BorderedButton("Select") {
                            onSearch()
                        }
                    }
                }
            }
            .navigationTitle(currentStep.title)
        }
    }
    
    func validate(currentStep: BikePreferenceStep, preferences: BikePreferences) -> ValidationError? {
        switch currentStep {
        case .type: if !preferences.mountain && !preferences.road && !preferences.hybrid {
            return .atLeastOneSelected
        }
        case .electric: if !preferences.electric && !preferences.nonElectric {
            return .atLeastOneSelected
        }
        case .priceRange: if !preferences.price_1 && !preferences.price_2 && !preferences.price_3 && !preferences.price_4 {
            return .atLeastOneSelected
        }
        case .summary: return nil
        }
        return nil
    }
    
    func validationMessage(_ validationError: ValidationError) -> String {
        switch validationError {
        case .atLeastOneSelected: return "Please choose at least one option"
        }
    }
    
    func onNext() {
        if let nextStep = currentStep.nextStep {
            currentStep = nextStep
        }
    }
    
    func onSearch() {
        do {
            try Prefs.saveBikePrefs(preferences)
            // TODO select first tab
        } catch {
            // TODO error handling
            print("couldn't save")
        }
    }
}

struct BikePreferencesSummaryView: View {
    @State var preferences: BikePreferences

    var body: some View {
        VStack(alignment: .leading) {
            Text("Type:")
            VStack(alignment: .leading) {
                if preferences.mountain {
                    Text("Mountain")
                        .summaryEntry()
                }
                if preferences.road {
                    Text("Road")
                        .summaryEntry()

                }
                if preferences.hybrid {
                    Text("Hybrid")
                        .summaryEntry()
                }
            }
            
            Text("Electric:")
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                if preferences.electric {
                    Text("Electric")
                        .summaryEntry()
                }
                if preferences.nonElectric {
                    Text("Non-Electric")
                        .summaryEntry()
                }
            }
            
            Text("Price:")
                .padding(.top, 10)

            VStack(alignment: .leading) {
                if preferences.price_1 {
                    Text("€")
                        .summaryEntry()
                }
                if preferences.price_2 {
                    Text("€€")
                        .summaryEntry()
                }
                if preferences.price_3 {
                    Text("€€€")
                        .summaryEntry()
                }
                if preferences.price_4 {
                    Text("€€€€")
                        .summaryEntry()
                }
            }
        }
    }
}

private extension Text {
    func summaryEntry() -> some View {
        font(.system(size: 30))
            .fontWeight(.medium)
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
