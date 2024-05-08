#if os(iOS)

import SwiftUI

struct Text2SpeechView: View {
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
                                HStack {
                                        Text(verbatim: "測試")
                                        Spacer()
                                        Speaker {
                                                Speech.speak("測試", isRomanization: false)
                                        }
                                }
                                HStack {
                                        Text(verbatim: "cak1 si3")
                                        Spacer()
                                        Speaker("cak1 si3")
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.TextToSpeech")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
