import SwiftUI
import CommonExtensions

@available(macOS 13.0, *)
struct FontSettingsView: View {
        private let minusImage: Image = Image(systemName: "minus")
        private let plusImage: Image = Image(systemName: "plus")

        @State private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)
        @State private var commentFontSize: Int = Int(AppSettings.commentFontSize)
        @State private var labelFontSize: Int = Int(AppSettings.labelFontSize)
        private let fontSizeRange: ClosedRange<Int> = AppSettings.fontSizeRange

        @State private var candidateFontMode: FontMode = AppSettings.candidateFontMode
        @State private var commentFontMode: FontMode = AppSettings.commentFontMode
        @State private var labelFontMode: FontMode = AppSettings.labelFontMode

        @State private var customCandidateFonts: [String] = AppSettings.customCandidateFonts
        @State private var customCommentFonts: [String] = AppSettings.customCommentFonts
        @State private var customLabelFonts: [String] = AppSettings.customLabelFonts

        @State private var animationState: Int = 0
        private func triggerAnimation() {
                animationState += 1
        }

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading) {
                                Form {
                                        Section {
                                                Picker("FontPreferencesView.FontSizePicker.Candidate", selection: $candidateFontSize) {
                                                        ForEach(fontSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: candidateFontSize) { newFontSize in
                                                        AppSettings.updateCandidateFontSize(to: newFontSize)
                                                }
                                                Picker("FontPreferencesView.FontModePicker.Candidate", selection: $candidateFontMode) {
                                                        Text("FontPreferencesView.FontMode.Default").tag(FontMode.default)
                                                        Text("FontPreferencesView.FontMode.System").tag(FontMode.system)
                                                        Text("FontPreferencesView.FontMode.Custom").tag(FontMode.custom)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: candidateFontMode) { newMode in
                                                        AppSettings.updateCandidateFontMode(to: newMode)
                                                        triggerAnimation()
                                                }
                                                if candidateFontMode.isCustom {
                                                        ForEach(customCandidateFonts.indices, id: \.self) { index in
                                                                HStack {
                                                                        Button(role: .destructive) {
                                                                                customCandidateFonts.remove(at: index)
                                                                                triggerAnimation()
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        FontPicker($customCandidateFonts[index], size: candidateFontSize, fallback: PresetConstant.PingFangHK, adoptFormStyle: true)
                                                                }
                                                        }
                                                        Button {
                                                                customCandidateFonts.append(PresetConstant.PingFangHK)
                                                                triggerAnimation()
                                                        } label: {
                                                                plusImage
                                                        }
                                                        .onChange(of: customCandidateFonts) { newFontNames in
                                                                AppSettings.updateCustomCandidateFonts(to: newFontNames)
                                                        }
                                                }
                                        }
                                        Section {
                                                Picker("FontPreferencesView.FontSizePicker.Comment", selection: $commentFontSize) {
                                                        ForEach(fontSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: commentFontSize) { newFontSize in
                                                        AppSettings.updateCommentFontSize(to: newFontSize)
                                                }
                                                Picker("FontPreferencesView.FontModePicker.Comment", selection: $commentFontMode) {
                                                        Text("FontPreferencesView.FontMode.Default").tag(FontMode.default)
                                                        Text("FontPreferencesView.FontMode.System").tag(FontMode.system)
                                                        Text("FontPreferencesView.FontMode.Custom").tag(FontMode.custom)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: commentFontMode) { newMode in
                                                        AppSettings.updateCommentFontMode(to: newMode)
                                                        triggerAnimation()
                                                }
                                                if commentFontMode.isCustom {
                                                        ForEach(customCommentFonts.indices, id: \.self) { index in
                                                                HStack {
                                                                        Button(role: .destructive) {
                                                                                customCommentFonts.remove(at: index)
                                                                                triggerAnimation()
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        FontPicker($customCommentFonts[index], size: commentFontSize, fallback: PresetConstant.HelveticaNeue, adoptFormStyle: true)
                                                                }
                                                        }
                                                        Button {
                                                                customCommentFonts.append(PresetConstant.HelveticaNeue)
                                                                triggerAnimation()
                                                        } label: {
                                                                plusImage
                                                        }
                                                        .onChange(of: customCommentFonts) { newFontNames in
                                                                AppSettings.updateCustomCommentFonts(to: newFontNames)
                                                        }
                                                }
                                        }
                                        Section {
                                                Picker("FontPreferencesView.FontSizePicker.SerialNumber", selection: $labelFontSize) {
                                                        ForEach(fontSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: labelFontSize) { newFontSize in
                                                        AppSettings.updateLabelFontSize(to: newFontSize)
                                                }
                                                Picker("FontPreferencesView.FontModePicker.SerialNumber", selection: $labelFontMode) {
                                                        Text("FontPreferencesView.FontMode.Default").tag(FontMode.default)
                                                        Text("FontPreferencesView.FontMode.System").tag(FontMode.system)
                                                        Text("FontPreferencesView.FontMode.Custom").tag(FontMode.custom)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: labelFontMode) { newMode in
                                                        AppSettings.updateLabelFontMode(to: newMode)
                                                        triggerAnimation()
                                                }
                                                if labelFontMode.isCustom {
                                                        ForEach(customLabelFonts.indices, id: \.self) { index in
                                                                HStack {
                                                                        Button(role: .destructive) {
                                                                                customLabelFonts.remove(at: index)
                                                                                triggerAnimation()
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        FontPicker($customLabelFonts[index], size: labelFontSize, fallback: PresetConstant.Menlo, adoptFormStyle: true)
                                                                }
                                                        }
                                                        Button {
                                                                customLabelFonts.append(PresetConstant.Menlo)
                                                                triggerAnimation()
                                                        } label: {
                                                                plusImage
                                                        }
                                                        .onChange(of: customLabelFonts) { newFontNames in
                                                                AppSettings.updateCustomLabelFonts(to: newFontNames)
                                                        }
                                                }
                                        }
                                }
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
                                .frame(maxWidth: 480)
                        }
                }
                .animation(.default, value: animationState)
                .navigationTitle("PreferencesView.NavigationTitle.Fonts")
        }
}
