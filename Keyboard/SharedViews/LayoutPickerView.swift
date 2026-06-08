import SwiftUI
import CommonExtensions

struct LayoutPickerView: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                let selectedLayout = context.keyboardLayout
                let isRunningOnPhone = context.isRunningOnPhone
                VStack(spacing: 0) {
                        ZStack {
                                Text("SettingsView.NavigationBar.HintText").font(.footnote).shallow()
                                HStack {
                                        NavigationLeadingBackButton()
                                        Spacer()
                                        NavigationTrailingExpansionButton().hidden()
                                }
                        }
                        .frame(height: context.keyboardInterface.isCompact ? PresetConstant.buttonLength : PresetConstant.buttonLengthXL)
                        ScrollView(.vertical) {
                                LazyVStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                ZStack {
                                                        RoundedRectangle(cornerRadius: 20).stroke(Material.regular, lineWidth: 1)
                                                        Grid(verticalSpacing: 12) {
                                                                GridRow {
                                                                        LayoutOptionView(layout: .qwerty, isSelected: selectedLayout.isQwerty)
                                                                        LayoutOptionView(layout: .tripleStroke, isSelected: selectedLayout.isTripleStroke)
                                                                        LayoutOptionView(layout: .nineKey, isSelected: selectedLayout.isNineKey)
                                                                        LayoutOptionView(layout: .fourteenKey, isSelected: selectedLayout.isFourteenKey).opacity(isRunningOnPhone ? 1 : 0)
                                                                }
                                                                GridRow {
                                                                        LayoutOptionView(layout: .fifteenKey, isSelected: selectedLayout.isFifteenKey)
                                                                        LayoutOptionView(layout: .eighteenKey, isSelected: selectedLayout.isEighteenKey)
                                                                        LayoutOptionView(layout: .nineteenKey, isSelected: selectedLayout.isNineteenKey)
                                                                        LayoutOptionView(layout: .twentyOneKey, isSelected: selectedLayout.isTwentyOneKey)
                                                                }
                                                                .opacity(isRunningOnPhone ? 1 : 0)
                                                        }
                                                        .padding(8)
                                                }
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                        }
                                }
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
                                VStack(spacing: 2) {
                                        if #available(iOSApplicationExtension 26.0, *) {
                                                ZStack {
                                                        Color.clear
                                                        ZStack(alignment: .bottomTrailing) {
                                                                Color.clear
                                                                Image(systemName: "checkmark.circle.fill")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .symbolRenderingMode(.multicolor)
                                                                        .frame(width: 11, height: 11)
                                                                        .padding(.bottom, 7)
                                                                        .padding(.trailing, 6)
                                                        }
                                                        .opacity(isSelected ? 1 : 0)
                                                        Image(systemName: layout.isNineKey ? "square.grid.3x3" : "keyboard")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                                                                .padding(.horizontal, layout.isNineKey ? 14 : 8)
                                                }
                                                .frame(width: 50, height: 50)
                                                .glassEffect(isSelected ? .regular : .clear, in: .circle)
                                        } else {
                                                ZStack {
                                                        Circle().fill(isSelected ? Material.regular : Material.ultraThick)
                                                        ZStack(alignment: .bottomTrailing) {
                                                                Color.clear
                                                                Image(systemName: "checkmark.circle.fill")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .symbolRenderingMode(.multicolor)
                                                                        .frame(width: 11, height: 11)
                                                                        .padding(.bottom, 7)
                                                                        .padding(.trailing, 6)
                                                        }
                                                        .opacity(isSelected ? 1 : 0)
                                                        Image(systemName: layout.isNineKey ? "square.grid.3x3" : "keyboard")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .foregroundStyle(isSelected ? Color.accentColor : Color.primary)
                                                                .padding(.horizontal, layout.isNineKey ? 14 : 8)
                                                }
                                                .frame(width: 50, height: 50)
                                        }
                                        Text(layout.labelName)
                                                .font(.footnote)
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(1)
                                }
                        }
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
