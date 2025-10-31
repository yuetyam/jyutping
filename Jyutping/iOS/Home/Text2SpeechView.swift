#if os(iOS)

import SwiftUI

struct Text2SpeechView: View {
        @State private var voiceIdentifier: String? = Speech.voiceIdentifier
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.Text2Speech.Notice1")
                        }
                        Section {
                                Text("IOSHomeTab.Text2Speech.Notice2")
                        }
                        Section {
                                Text("IOSHomeTab.Text2Speech.Notice3")
                                Text("IOSHomeTab.Text2Speech.Notice4")
                        }
                        Section {
                                Text("IOSHomeTab.Text2Speech.Notice5")
                                Text("IOSHomeTab.Text2Speech.Notice6")
                        }
                        Section {
                                HStack {
                                        Text(verbatim: "測試")
                                        Spacer()
                                        Speaker {
                                                Speech.speak("測試", isRomanization: false)
                                                voiceIdentifier = Speech.voiceIdentifier
                                        }
                                }
                                HStack {
                                        Text(verbatim: "cak1 si3")
                                        Spacer()
                                        Speaker {
                                                Speech.speak("cak1 si3", isRomanization: true)
                                                voiceIdentifier = Speech.voiceIdentifier
                                        }
                                }
                        }
                        if let voiceIdentifier {
                                Section {
                                        HStack(spacing: 0) {
                                                Text(verbatim: "System")
                                                Text.separator
                                                Text(verbatim: Device.system)
                                        }
                                        HStack(spacing: 0) {
                                                Text(verbatim: "Version")
                                                Text.separator
                                                Text(verbatim: AppMaster.version)
                                        }
                                        HStack(spacing: 0) {
                                                Text(verbatim: "Voice")
                                                Text.separator
                                                Text(verbatim: voiceIdentifier)
                                        }
                                }
                                .font(.footnote)
                        }
                        Section {
                                Text("IOSHomeTab.Text2Speech.FeedbackSuggestion").font(.footnote)
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.TextToSpeech")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
