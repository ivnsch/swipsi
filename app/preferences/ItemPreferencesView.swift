import SwiftUI
import SwiftData

struct ItemPreferences: Codable, Equatable {
    var necklace: Bool = false
    var bracelet: Bool = false
    var ring: Bool = false
    var earring: Bool = false
    var price_1: Bool = false
    var price_2: Bool = false
    var price_3: Bool = false
    var price_4: Bool = false
    
    init(necklace: Bool, bracelet: Bool, ring: Bool, earring: Bool, price_1: Bool, price_2: Bool, price_3: Bool, price_4: Bool) {
        self.necklace = necklace
        self.bracelet = bracelet
        self.ring = ring
        self.earring = earring
        self.earring = earring
        self.earring = earring
        self.price_1 = price_1
        self.price_2 = price_2
        self.price_3 = price_3
        self.price_4 = price_4
    }
}

enum ValidationError {
    case atLeastOneSelected
}

enum ItemPreferenceStep {
    case type, priceRange, summary
    
    var title: String {
        switch self {
            case .type: return "Type"
            case .priceRange: return "Price Range"
            case .summary: return "Summary"
        }
    }
    
    var previousStep: ItemPreferenceStep? {
        switch self {
        case .type: return nil
        case .priceRange: return .type
        case .summary: return .priceRange
        }
    }
    
    var nextStep: ItemPreferenceStep? {
        switch self {
        case .type: return .priceRange
        case .priceRange: return .summary
        case .summary: return nil

        }
    }
}

struct PreferencesOutlineView: View {
    @State private var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            if let prefs = preferences() {
                // if there are already preferences saved, show either init summary (same as summary but with "edit" button instead of "save")
                // or preferences flow if we selected edit on said view
                if isEditing {
                    ItemPreferencesView(preferences: prefs, onSave: {
                        onSavePreferences()
                    })
                } else {
                    InitSummaryView(preferences: prefs, onEdit: {
                        isEditing = true
                    })
                }
            } else {
                // if there are no preferences yet, start flow with all false defaults
                ItemPreferencesView(preferences: ItemPreferences(
                    necklace: false, bracelet: false, ring: false, earring: false,
                    price_1: false, price_2: false, price_3: false, price_4: false
                ), onSave: {
                    onSavePreferences()
                })
            }
        }
        .onAppear() {
            if preferences() == nil {
                isEditing = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.mainBg.ignoresSafeArea())
    }
    
    func onSavePreferences() {
        isEditing = false
    }
    
    func preferences() -> ItemPreferences? {
        do {
            return try Prefs.loadItemPrefs()
        } catch {
            // TODO error handling
            print("error loading prefs: \(error)")
            return nil
        }
    }
}

struct InitSummaryView: View {
    @State var preferences: ItemPreferences
    let onEdit: () -> Void
    
    var body: some View {
        VStack {
            ItemPreferencesSummaryView(preferences: preferences)
            BorderedButton("Edit") {
                onEdit()
            }
            .opacity(0.5)
        }
    }
}

struct ItemPreferencesView: View {
    @State var preferences: ItemPreferences
    @State private var currentStep: ItemPreferenceStep = .type
    
    var onSave: () -> Void
    
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
                    ItemTypeView(preferences: $preferences)
                case .priceRange:
                    ItemPriceRangeView(preferences: $preferences)
                case .summary:
                    ItemPreferencesSummaryView(preferences: preferences)
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
                        BorderedButton("Save") {
                            onSearch()
                            onSave()
                        }
                    }
                }
            }
            .navigationTitle(currentStep.title)
        }
    }
    
    func validate(currentStep: ItemPreferenceStep, preferences: ItemPreferences) -> ValidationError? {
        switch currentStep {
        case .type: if !preferences.necklace && !preferences.bracelet && !preferences.ring  && !preferences.earring {
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
            try Prefs.saveItemPrefs(preferences)
            // TODO select first tab
        } catch {
            // TODO error handling
            print("couldn't save")
        }
    }
}

struct ItemPreferencesSummaryView: View {
    @State var preferences: ItemPreferences

    var body: some View {
        VStack(alignment: .leading) {
            Text("Type:")
            VStack(alignment: .leading) {
                
                if preferences.necklace {
                    Text("Necklace")
                        .summaryEntry()
                }
                if preferences.bracelet {
                    Text("Bracelet")
                        .summaryEntry()
                }
                if preferences.ring {
                    Text("Ring")
                        .summaryEntry()
                }
                if preferences.earring {
                    Text("Earring")
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

struct ItemTypeView: View {
    @Binding var preferences: ItemPreferences
    
    var necklace: Bool = false
    var bracelet: Bool = false
    var ring: Bool = false
    var earring: Bool = false
    var piercing: Bool = false
    var body: some View {
        VStack {
            Button("Necklace")
            {
                setAllToFalse()
                preferences.necklace = !preferences.necklace
            }
            .preferenceButton(selected: preferences.necklace)
            Button("Bracelet") {
                setAllToFalse()
                preferences.bracelet = !preferences.bracelet
            }
            .preferenceButton(selected: preferences.bracelet)
            Button("Ring") {
                setAllToFalse()
                preferences.ring = !preferences.ring
            }
            .preferenceButton(selected: preferences.ring)
            Button("Earring") {
                setAllToFalse()
                preferences.earring = !preferences.earring
            }
            .preferenceButton(selected: preferences.earring)
        }
    }
    
    func setAllToFalse() {
        preferences.necklace = false
        preferences.bracelet = false
        preferences.ring = false
        preferences.earring = false
    }
}

extension Button {
    func preferenceButton(selected: Bool) -> some View {
        foregroundColor(selected ? Color.black : Color.gray)
            .font(.system(size: 30))
            .padding(.bottom, 10)
    }
}

struct ItemPriceRangeView: View {
    @Binding var preferences: ItemPreferences

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
