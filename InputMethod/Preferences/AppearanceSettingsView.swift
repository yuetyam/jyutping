import SwiftUI
import CoreIME
import CommonExtensions

struct AppearanceSettingsView: View {

        @Environment(\.colorScheme) private var colorScheme

        @State private var lineSpacing: Int = AppSettings.candidateLineSpacing
        @State private var pageCornerRadius: Int = AppSettings.pageCornerRadius
        @State private var contentInsets: Int = AppSettings.contentInsets
        @State private var innerCornerRadius: Int = AppSettings.innerCornerRadius
        private let lineSpacingRange: ClosedRange<Int> = AppSettings.candidateLineSpacingRange
        private let cornerRadiusRange: ClosedRange<Int> = AppSettings.cornerRadiusRange

        @State private var isThickerGlassPreferred = AppSettings.isThickerGlassPreferred
        @State private var preferredAccentColor = AppSettings.preferredAccentColor

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading) {
                                Form {
                                        Section {
                                                Picker("AppearanceSettingsView.CandidateLineSpacing.PickerTitle", selection: $lineSpacing) {
                                                        ForEach(lineSpacingRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: lineSpacing) { _, newLineSpacing in
                                                        AppSettings.updateCandidateLineSpacing(to: newLineSpacing)
                                                }
                                                Picker("AppearanceSettingsView.CandidatePageCornerRadius.PickerTitle", selection: $pageCornerRadius) {
                                                        ForEach(cornerRadiusRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: pageCornerRadius) { _, newValue in
                                                        AppSettings.updatePageCornerRadius(to: newValue)
                                                }
                                                Picker("AppearanceSettingsView.CandidatePageInsets.PickerTitle", selection: $contentInsets) {
                                                        ForEach(cornerRadiusRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: contentInsets) { _, newValue in
                                                        AppSettings.updateContentInsets(to: newValue)
                                                }
                                                Picker("AppearanceSettingsView.CandidateCornerRadius.PickerTitle", selection: $innerCornerRadius) {
                                                        ForEach(cornerRadiusRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: innerCornerRadius) { _, newValue in
                                                        AppSettings.updateInnerCornerRadius(to: newValue)
                                                }
                                        }
                                        if #available(macOS 26.0, *) {
                                                Section {
                                                        Toggle("AppearanceSettingsView.EnhancedGlass.Thicker.ToggleTitle", isOn: $isThickerGlassPreferred)
                                                                .toggleStyle(.switch)
                                                                .onChange(of: isThickerGlassPreferred) { _, isOn in
                                                                        AppSettings.updatePreferredThickerGlass(to: isOn)
                                                                }
                                                }
                                        }
                                        Section {
                                                HStack(alignment: .top, spacing: 2) {
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .auto, color: .accentColor, name: "AccentColor.Option1.Auto")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .monochrome, color: .textBackgroundColor, name: "AccentColor.Option3.Monochrome")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .reversedMonochrome, color: .textColor, name: "AccentColor.Option4.ReversedMonochrome")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .blue, color: colorScheme.blue, name: "AccentColor.Option11.Blue")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .purple, color: colorScheme.purple, name: "AccentColor.Option12.Purple")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .pink, color: colorScheme.pink, name: "AccentColor.Option13.Pink")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .red, color: colorScheme.red, name: "AccentColor.Option14.Red")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .orange, color: colorScheme.orange, name: "AccentColor.Option15.Orange")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .yellow, color: colorScheme.yellow, name: "AccentColor.Option16.Yellow")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .green, color: colorScheme.green, name: "AccentColor.Option17.Green")
                                                        AccentPickerView(preferred: $preferredAccentColor, accent: .graphite, color: colorScheme.graphite, name: "AccentColor.Option18.Graphite")
                                                }
                                        } header: {
                                                Text("AccentColor.AppearanceSettingsView.SectionHeader").textCase(nil)
                                        }
                                        .onChange(of: preferredAccentColor) { _, newOption in
                                                AppSettings.updatePreferredAccentColor(to: newOption)
                                        }
                                }
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
                                .stack(cornerRadius: 16)
                                .frame(maxWidth: 500)
                        }
                        .padding(8)
                }
                .navigationTitle("AppearanceSettingsView.NavigationTitle.TitleKey")
        }
}

private struct AccentPickerView: View {
        @Binding var preferred: PreferredAccentColor
        let accent: PreferredAccentColor
        let color: Color
        let name: LocalizedStringKey
        @State private var textOpacity: Double = 0
        var body: some View {
                let isSelected: Bool = (preferred == accent)
                VStack(spacing: 4) {
                        ZStack {
                                Circle().stroke(color, lineWidth: 2).opacity(isSelected ? 1 : 0)
                                Circle().fill(color).padding(3)
                        }
                        .frame(width: 20, height: 20)
                        Text(name)
                                .font(.caption2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .frame(width: 36)
                                .opacity(isSelected ? 1 : textOpacity)
                }
                .contentShape(.rect)
                .onHover { isHovering in
                        textOpacity = isHovering ? 0.75 : 0
                }
                .onTapGesture {
                        preferred = accent
                }
        }
}
