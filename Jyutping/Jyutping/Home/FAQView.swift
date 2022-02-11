import SwiftUI

@available(iOS 14.0, *)
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
                                                Text("本應用程式使用系統提供个語音朗讀功能。")
                                                Spacer()
                                        }
                                        if !(Speech.isLanguagesEnabled) {
                                                HStack {
                                                        Text.dotMark
                                                        Text("爲保證發音質素，推薦到 **設定** → **一般** → **語言與地區** 度添加 **繁體中文(香港)** 語言。")
                                                        Spacer()
                                                }
                                        }
                                        HStack {
                                                Text.dotMark
                                                Text("爲提高發音質素，推薦到 **設定** → **輔助功能** → **旁白** → **語音** 度添加 **繁體中文(香港)** 語音。")
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

@available(iOS 14.0, *)
struct FAQView_Previews: PreviewProvider {
        static var previews: some View {
                FAQView()
        }
}
