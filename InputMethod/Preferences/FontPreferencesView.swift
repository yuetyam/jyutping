import SwiftUI
import CommonExtensions

struct FontPreferencesView: View {

        private let minusImage: Image = Image(systemName: "minus")
        private let plusImage: Image = Image(systemName: "plus")

        @State private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)
        @State private var commentFontSize: Int = Int(AppSettings.commentFontSize)
        @State private var labelFontSize: Int = Int(AppSettings.labelFontSize)
        private let fontSizeRange: Range<Int> = AppSettings.fontSizeRange

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
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack {
                                                Picker("FontPreferencesView.CandidateFontSize", selection: $candidateFontSize) {
                                                        ForEach(fontSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: candidateFontSize) { newFontSize in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCandidateFontSize(to: newFontSize)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("FontPreferencesView.CandidateFont", selection: $candidateFontMode) {
                                                        Text("FontPreferencesView.Default").tag(FontMode.default)
                                                        Text("FontPreferencesView.System").tag(FontMode.system)
                                                        Text("FontPreferencesView.Custom").tag(FontMode.custom)
                                                }
                                                .scaledToFit()
                                                .onChange(of: candidateFontMode) { newMode in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCandidateFontMode(to: newMode)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        if candidateFontMode.isCustom {
                                                VStack {
                                                        ForEach(0..<customCandidateFonts.count, id: \.self) { index in
                                                                HStack {
                                                                        Button {
                                                                                customCandidateFonts.remove(at: index)
                                                                                triggerAnimation()
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        FontPicker($customCandidateFonts[index], size: candidateFontSize, fallback: Constant.PingFangHK)
                                                                        Spacer()
                                                                }
                                                        }
                                                        HStack {
                                                                Button {
                                                                        customCandidateFonts.append(Constant.PingFangHK)
                                                                        triggerAnimation()
                                                                } label: {
                                                                        plusImage
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customCandidateFonts) { newFontNames in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomCandidateFonts(to: newFontNames)
                                                        }
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("FontPreferencesView.CommentFontSize", selection: $commentFontSize) {
                                                        ForEach(fontSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: commentFontSize) { newFontSize in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCommentFontSize(to: newFontSize)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("FontPreferencesView.CommentFont", selection: $commentFontMode) {
                                                        Text("FontPreferencesView.Default").tag(FontMode.default)
                                                        Text("FontPreferencesView.System").tag(FontMode.system)
                                                        Text("FontPreferencesView.Custom").tag(FontMode.custom)
                                                }
                                                .scaledToFit()
                                                .onChange(of: commentFontMode) { newMode in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCommentFontMode(to: newMode)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        if commentFontMode.isCustom {
                                                VStack {
                                                        ForEach(0..<customCommentFonts.count, id: \.self) { index in
                                                                HStack {
                                                                        Button {
                                                                                customCommentFonts.remove(at: index)
                                                                                triggerAnimation()
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        FontPicker($customCommentFonts[index], size: commentFontSize, fallback: Constant.HelveticaNeue)
                                                                        Spacer()
                                                                }
                                                        }
                                                        HStack {
                                                                Button {
                                                                        customCommentFonts.append(Constant.HelveticaNeue)
                                                                        triggerAnimation()
                                                                } label: {
                                                                        plusImage
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customCommentFonts) { newFontNames in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomCommentFonts(to: newFontNames)
                                                        }
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("FontPreferencesView.SerialNumberFontSize", selection: $labelFontSize) {
                                                        ForEach(fontSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: labelFontSize) { newFontSize in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateLabelFontSize(to: newFontSize)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("FontPreferencesView.SerialNumberFont", selection: $labelFontMode) {
                                                        Text("FontPreferencesView.Default").tag(FontMode.default)
                                                        Text("FontPreferencesView.System").tag(FontMode.system)
                                                        Text("FontPreferencesView.Custom").tag(FontMode.custom)
                                                }
                                                .scaledToFit()
                                                .onChange(of: labelFontMode) { newMode in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateLabelFontMode(to: newMode)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        if labelFontMode.isCustom {
                                                VStack {
                                                        ForEach(0..<customLabelFonts.count, id: \.self) { index in
                                                                HStack {
                                                                        Button {
                                                                                customLabelFonts.remove(at: index)
                                                                                triggerAnimation()
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        FontPicker($customLabelFonts[index], size: labelFontSize, fallback: Constant.Menlo)
                                                                        Spacer()
                                                                }
                                                        }
                                                        HStack {
                                                                Button {
                                                                        customLabelFonts.append(Constant.Menlo)
                                                                        triggerAnimation()
                                                                } label: {
                                                                        plusImage
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customLabelFonts) { newFontNames in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomLabelFonts(to: newFontNames)
                                                        }
                                                }
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .animation(.default, value: animationState)
                .navigationTitle("PreferencesView.NavigationTitle.Fonts")
        }
}
