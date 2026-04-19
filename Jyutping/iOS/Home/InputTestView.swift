#if os(iOS)

import SwiftUI
import CommonExtensions

struct InputTestView: View {

        @State private var inputText: String = String.empty

        @State private var autoCapitalization: AutoCapitalization = .sentences
        private let AutoCapitalizationPickerTitle: String = "Auto Capitalization"

        @State private var isAutocorrectionOn: Bool = false
        private let AutoCorrectionToggleTitle: String = "Auto Correction"

        @State private var requestedKeyboardType: UIKeyboardType = .default
        private let KeyboardTypePickerTitle: String = "Keyboard Type"

        @State private var returnKeyType: ReturnKeyType = .return
        private let SubmitLabelPickerTitle: String = "Return Key"

        @State private var colorScheme: ColorScheme? = nil
        private let ColorSchemePickerTitle: String = "Color Scheme"

        var body: some View {
                List {
                        Section {
                                TextField("TextField.InputTextField", text: $inputText)
                                        .textInputAutocapitalization(autoCapitalization.behavior)
                                        .autocorrectionDisabled(isAutocorrectionOn.negative)
                                        .keyboardType(requestedKeyboardType)
                                        .submitLabel(returnKeyType.submitLabel)
                                        .preferredColorScheme(colorScheme)
                        }
                        Section {
                                Picker(AutoCapitalizationPickerTitle, selection: $autoCapitalization) {
                                        Text(AutoCapitalization.never.title).tag(AutoCapitalization.never)
                                        Text(AutoCapitalization.sentences.title).tag(AutoCapitalization.sentences)
                                        Text(AutoCapitalization.words.title).tag(AutoCapitalization.words)
                                        Text(AutoCapitalization.characters.title).tag(AutoCapitalization.characters)
                                }
                                Toggle(AutoCorrectionToggleTitle, isOn: $isAutocorrectionOn)
                                Picker(KeyboardTypePickerTitle, selection: $requestedKeyboardType) {
                                        Text(verbatim: "Default").tag(UIKeyboardType.default)
                                        Text(verbatim: "ASCII Capable").tag(UIKeyboardType.asciiCapable)
                                        Text(verbatim: "Web Search").tag(UIKeyboardType.webSearch)
                                        Text(verbatim: "URL").tag(UIKeyboardType.URL)
                                        Text(verbatim: "Email Address").tag(UIKeyboardType.emailAddress)
                                        Text(verbatim: "Twitter").tag(UIKeyboardType.twitter)
                                        Text(verbatim: "Numbers & Punctuation").tag(UIKeyboardType.numbersAndPunctuation)
                                        Text(verbatim: "Number Pad").tag(UIKeyboardType.numberPad)
                                        Text(verbatim: "Decimal Pad").tag(UIKeyboardType.decimalPad)
                                        Text(verbatim: "Phone Pad").tag(UIKeyboardType.phonePad)
                                        Text(verbatim: "Name Phone Pad").tag(UIKeyboardType.namePhonePad)
                                        Text(verbatim: "ASCII Capable Number Pad").tag(UIKeyboardType.asciiCapableNumberPad)
                                }
                                Picker(SubmitLabelPickerTitle, selection: $returnKeyType) {
                                        Text(verbatim: ReturnKeyType.done.title).tag(ReturnKeyType.done)
                                        Text(verbatim: ReturnKeyType.go.title).tag(ReturnKeyType.go)
                                        Text(verbatim: ReturnKeyType.send.title).tag(ReturnKeyType.send)
                                        Text(verbatim: ReturnKeyType.join.title).tag(ReturnKeyType.join)
                                        Text(verbatim: ReturnKeyType.route.title).tag(ReturnKeyType.route)
                                        Text(verbatim: ReturnKeyType.search.title).tag(ReturnKeyType.search)
                                        Text(verbatim: ReturnKeyType.return.title).tag(ReturnKeyType.return)
                                        Text(verbatim: ReturnKeyType.next.title).tag(ReturnKeyType.next)
                                        Text(verbatim: ReturnKeyType.continue.title).tag(ReturnKeyType.continue)
                                }
                                HStack {
                                        Text(verbatim: ColorSchemePickerTitle)
                                        Spacer()
                                        Picker(ColorSchemePickerTitle, selection: $colorScheme) {
                                                Text(verbatim: "Auto").tag(nil as ColorScheme?)
                                                Text(verbatim: "Light").tag(ColorScheme.light as ColorScheme?)
                                                Text(verbatim: "Dark").tag(ColorScheme.dark as ColorScheme?)
                                        }
                                        .pickerStyle(.segmented)
                                        .fixedSize()
                                }
                        }
                }
                .navigationTitle("IOSHomeTab.NavigationTitle.InputTest")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private enum AutoCapitalization: Int, CaseIterable {
        case never
        case sentences
        case words
        case characters
        var behavior: TextInputAutocapitalization {
                switch self {
                case .never: .never
                case .sentences: .sentences
                case .words: .words
                case .characters: .characters
                }
        }
        var title: String {
                switch self {
                case .never: "Never"
                case .characters: "Characters"
                case .words: "Words"
                case .sentences: "Sentences"
                }
        }
}

private enum ReturnKeyType: Int, CaseIterable {
        case done, go, send, join, route, search, `return`, next, `continue`;
        var submitLabel: SubmitLabel {
                switch self {
                case .done: .done
                case .go: .go
                case .send: .send
                case .join: .join
                case .route: .route
                case .search: .search
                case .return: .return
                case .next: .next
                case .continue: .continue
                }
        }
        var title: String {
                switch self {
                case .done: "Done"
                case .go: "Go"
                case .send: "Send"
                case .join: "Join"
                case .route: "Route"
                case .search: "Search"
                case .return: "Return"
                case .next: "Next"
                case .continue: "Continue"
                }
        }
}

#endif
