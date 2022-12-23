#if os(iOS)

import SwiftUI

struct Text2SpeechView: View {
        var body: some View {
                List {
                        Section {
                                Text("tts.notice.0")
                        }
                        Section {
                                VStack(alignment: .leading, spacing: 24) {
                                        Text("tts.notice.1")
                                        Text("tts.notice.2")
                                        Text("tts.notice.3")
                                }
                        }
                        Section {
                                HStack {
                                        Text(verbatim: "測試")
                                        Spacer()
                                        Speaker("測試")
                                }
                                HStack {
                                        Text(verbatim: "cak1 si3")
                                        Spacer()
                                        Speaker("cak1 si3")
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("Text to Speech")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
