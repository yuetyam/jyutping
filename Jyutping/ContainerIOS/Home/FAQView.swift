import SwiftUI

struct FAQView: View {
        var body: some View {
                List {
                        Section {
                                Text("Can I use with external keyboards?").font(.headline)
                                Text("Unfortunately not. Third-party keyboard apps can't communicate with external keyboards due to system limitations.")
                        }
                        Section {
                                Text("What does “Allow Full Access” do?").font(.headline)
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
                                Text("All other features don't require Full Access").textCase(.none)
                        }

                        if !(Speech.isLanguagesEnabled && Speech.isEnhancedVoiceAvailable) {
                                Section {
                                        Text("Why is this App's Text-to-Speech voice so odd?").font(.headline)
                                        HStack {
                                                Text.dotMark
                                                Text("tts.notice.1")
                                                Spacer()
                                        }
                                        if !(Speech.isLanguagesEnabled) {
                                                HStack {
                                                        Text.dotMark
                                                        Text("tts.notice.2")
                                                        Spacer()
                                                }
                                        }
                                        HStack {
                                                Text.dotMark
                                                Text("tts.notice.3")
                                                Spacer()
                                        }
                                }
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("FAQ")
                .navigationBarTitleDisplayMode(.inline)
        }
}
