import SwiftUI

struct CandidateFontPreferencesView: View {

        @State private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)
        @State private var candidateFontMode: Int = 1

        @State private var commentFontSize: Int = Int(AppSettings.commentFontSize)
        @State private var commentFontMode: Int = 1

        @State private var labelFontSize: Int = Int(AppSettings.labelFontSize)
        @State private var labelFontMode: Int = 1

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
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCandidateFontSize(to: newFontSize)
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
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCommentFontSize(to: newFontSize)
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
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateLabelFontSize(to: newFontSize)
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
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .background(.ultraThinMaterial)
                .navigationTitle("Fonts")
        }
}
