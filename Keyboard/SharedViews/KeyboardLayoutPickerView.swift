import SwiftUI
import CommonExtensions

struct KeyboardLayoutPickerView: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                let selectedLayout = context.keyboardLayout
                VStack(spacing: 0) {
                        HStack {
                                NavigationLeadingBackButton()
                                Spacer()
                        }
                        if context.keyboardInterface.isPhoneLandscape {
                                VStack(alignment: .leading) {
                                        HStack {
                                                LayoutOptionView(layout: .qwerty, isSelected: selectedLayout.isQwerty)
                                                LayoutOptionView(layout: .tripleStroke, isSelected: selectedLayout.isTripleStroke)
                                                LayoutOptionView(layout: .nineKey, isSelected: selectedLayout.isNineKey)
                                                LayoutOptionView(layout: .fourteenKey, isSelected: selectedLayout.isFourteenKey)
                                        }
                                        HStack {
                                                LayoutOptionView(layout: .fifteenKey, isSelected: selectedLayout.isFifteenKey)
                                                LayoutOptionView(layout: .eighteenKey, isSelected: selectedLayout.isEighteenKey)
                                                LayoutOptionView(layout: .nineteenKey, isSelected: selectedLayout.isNineteenKey)
                                                LayoutOptionView(layout: .twentyOneKey, isSelected: selectedLayout.isTwentyOneKey)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                        } else {
                                VStack(alignment: .leading) {
                                        HStack {
                                                LayoutOptionView(layout: .qwerty, isSelected: selectedLayout.isQwerty)
                                                LayoutOptionView(layout: .tripleStroke, isSelected: selectedLayout.isTripleStroke)
                                                LayoutOptionView(layout: .nineKey, isSelected: selectedLayout.isNineKey)
                                        }
                                        HStack {
                                                LayoutOptionView(layout: .fourteenKey, isSelected: selectedLayout.isFourteenKey)
                                                LayoutOptionView(layout: .fifteenKey, isSelected: selectedLayout.isFifteenKey)
                                                LayoutOptionView(layout: .eighteenKey, isSelected: selectedLayout.isEighteenKey)
                                        }
                                        HStack {
                                                LayoutOptionView(layout: .nineteenKey, isSelected: selectedLayout.isNineteenKey)
                                                LayoutOptionView(layout: .twentyOneKey, isSelected: selectedLayout.isTwentyOneKey)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                        }
                }
        }
}

private struct LayoutOptionView: View {
        @EnvironmentObject private var context: KeyboardViewController
        let layout: KeyboardLayout
        let isSelected: Bool
        var body: some View {
                Button {
                        AudioFeedback.modified()
                        context.triggerSelectionHapticFeedback()
                        context.updateKeyboardLayout(to: layout)
                } label: {
                        ZStack {
                                Color.interactiveClear
                                VStack(spacing: 4) {
                                        Image(systemName: layout.isNineKey ? "square.grid.3x3" : "keyboard")
                                                .font(layout.isNineKey ? .title : .largeTitle)
                                        Text(layout.labelName)
                                                .font(.footnote)
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(1)
                                }
                                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                        }
                        .frame(width: 100, height: 64)
                }
                .buttonStyle(.plain)
        }
}

private extension KeyboardLayout {
        var labelName: String {
                return Self.nameMap[self] ?? "?"
        }
        private static let nameMap: [KeyboardLayout: String] = [
                .qwerty       : String(localized: "SettingsView.KeyboardLayout.Option.QWERTY"),
                .tripleStroke : String(localized: "SettingsView.KeyboardLayout.Option.TripleStroke"),
                .nineKey      : String(localized: "SettingsView.KeyboardLayout.Option.NineKey"),
                .fourteenKey  : String(localized: "SettingsView.KeyboardLayout.Option.FourteenKey"),
                .fifteenKey   : String(localized: "SettingsView.KeyboardLayout.Option.FifteenKey"),
                .eighteenKey  : String(localized: "SettingsView.KeyboardLayout.Option.EighteenKey"),
                .nineteenKey  : String(localized: "SettingsView.KeyboardLayout.Option.NineteenKey"),
                .twentyOneKey : String(localized: "SettingsView.KeyboardLayout.Option.TwentyOneKey"),
        ]
}
