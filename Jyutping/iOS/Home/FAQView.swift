#if os(iOS)

import SwiftUI

struct FAQView: View {
        var body: some View {
                List {
                        Section {
                                Text("Can I use with external keyboards?").font(.significant)
                                Text("Unfortunately not. Third-party keyboard apps can't communicate with external keyboards due to system limitations.")
                        }
                        Section {
                                Text("What does “Allow Full Access” do?").font(.significant)
                                if Device.isPad {
                                        Text("Enable a button on the keyboard for pasting texts from Clipboard")
                                } else {
                                        HStack {
                                                Text(verbatim: "1.").font(.system(size: 15, design: .monospaced))
                                                Text("Haptic Feedback")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "2.").font(.system(size: 15, design: .monospaced))
                                                Text("Paste texts from Clipboard")
                                                Spacer()
                                        }
                                }
                        } footer: {
                                Text("All other features don't require Full Access").textCase(nil)
                        }

                        Section {
                                Text("faq.heading.tts").font(.significant)
                                HStack {
                                        Text.dotMark
                                        Text("tts.notice.0")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("tts.notice.1")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("tts.notice.2")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("tts.notice.3")
                                        Spacer()
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("FAQ")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
