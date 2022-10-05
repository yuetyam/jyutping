import SwiftUI

struct CandidateFontPreferencesView: View {

        @AppStorage(SettingsKeys.CandidateFontSize) private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)
        @AppStorage(SettingsKeys.CommentFontSize) private var commentFontSize: Int = Int(AppSettings.commentFontSize)
        @AppStorage(SettingsKeys.LabelFontSize) private var labelFontSize: Int = Int(AppSettings.labelFontSize)

        @AppStorage(SettingsKeys.CandidateFontMode) private var candidateFontMode: Int = AppSettings.candidateFontMode.rawValue
        @AppStorage(SettingsKeys.CommentFontMode) private var commentFontMode: Int = AppSettings.commentFontMode.rawValue
        @AppStorage(SettingsKeys.LabelFontMode) private var labelFontMode: Int = AppSettings.labelFontMode.rawValue

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack {
                                                Picker("Candidate Font Size", selection: $candidateFontSize) {
                                                        ForEach(12..<23, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: candidateFontSize) { newFontSize in
                                                        AppSettings.updateCandidateFontSize(to: newFontSize)
                                                        DispatchQueue.preferences.async {
                                                                Font.updateCandidateFont(size: CGFloat(newFontSize))
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("Candidate Font", selection: $candidateFontMode) {
                                                        Text("Default").tag(1)
                                                        Text("System").tag(2)
                                                        Text("Custom").tag(3)
                                                }
                                                .pickerStyle(.radioGroup)
                                                .scaledToFit()
                                                .onChange(of: candidateFontMode) { newValue in
                                                        let newMode: FontMode = FontMode.mode(of: newValue)
                                                        AppSettings.updateCandidateFontMode(to: newMode)
                                                        DispatchQueue.preferences.async {
                                                                switch newMode {
                                                                case .default:
                                                                        Font.updateCandidateFont()
                                                                case .system:
                                                                        Font.updateCandidateFont(isSystemFontPreferred: true)
                                                                case .custom:
                                                                        Font.updateCandidateFont()
                                                                }
                                                        }
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("Comment Font Size", selection: $commentFontSize) {
                                                        ForEach(12..<23, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: commentFontSize) { newFontSize in
                                                        AppSettings.updateCommentFontSize(to: newFontSize)
                                                        DispatchQueue.preferences.async {
                                                                Font.updateCommentFont(size: CGFloat(newFontSize))
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("Comment Font", selection: $commentFontMode) {
                                                        Text("Default").tag(1)
                                                        Text("System").tag(2)
                                                        Text("Custom").tag(3)
                                                }
                                                .pickerStyle(.radioGroup)
                                                .scaledToFit()
                                                .onChange(of: commentFontMode) { newValue in
                                                        let newMode: FontMode = FontMode.mode(of: newValue)
                                                        AppSettings.updateCommentFontMode(to: newMode)
                                                        DispatchQueue.preferences.async {
                                                                switch newMode {
                                                                case .default:
                                                                        Font.updateCommentFont()
                                                                case .system:
                                                                        Font.updateCommentFont()
                                                                case .custom:
                                                                        Font.updateCommentFont()
                                                                }
                                                        }
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("Serial Number Font Size", selection: $labelFontSize) {
                                                        ForEach(12..<23, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: labelFontSize) { newFontSize in
                                                        AppSettings.updateLabelFontSize(to: newFontSize)
                                                        DispatchQueue.preferences.async {
                                                                Font.updateLabelFont(size: CGFloat(newFontSize))
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("Serial Number Font", selection: $labelFontMode) {
                                                        Text("Default").tag(1)
                                                        Text("System").tag(2)
                                                        Text("Custom").tag(3)
                                                }
                                                .pickerStyle(.radioGroup)
                                                .scaledToFit()
                                                .onChange(of: labelFontMode) { newValue in
                                                        let newMode: FontMode = FontMode.mode(of: newValue)
                                                        AppSettings.updateLabelFontMode(to: newMode)
                                                        DispatchQueue.preferences.async {
                                                                switch newMode {
                                                                case .default:
                                                                        Font.updateLabelFont()
                                                                case .system:
                                                                        Font.updateLabelFont()
                                                                case .custom:
                                                                        Font.updateLabelFont()
                                                                }
                                                        }
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("Fonts")
        }
}
