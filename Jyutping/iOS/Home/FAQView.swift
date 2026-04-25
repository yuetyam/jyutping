#if os(iOS)

import SwiftUI

struct FAQView: View {
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.FAQ.Question.ExternalKeyboards").font(.headline)
                                Text("IOSHomeTab.FAQ.Answer.ExternalKeyboards")
                        }
                        Section {
                                Text("IOSHomeTab.FAQ.Question.FullAccess").font(.headline)
                                if Device.isPad {
                                        Text("IOSHomeTab.FAQ.Answer.FullAccess.Row2.Clipboard")
                                } else {
                                        HStack {
                                                Text(verbatim: "1.").font(.footnote).monospacedDigit()
                                                Text("IOSHomeTab.FAQ.Answer.FullAccess.Row1.Haptic")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "2.").font(.footnote).monospacedDigit()
                                                Text("IOSHomeTab.FAQ.Answer.FullAccess.Row2.Clipboard")
                                                Spacer()
                                        }
                                }
                        }
                        Section {
                                Text("IOSHomeTab.FAQ.Question.TTS").font(.headline)
                                Label("IOSHomeTab.Text2Speech.Notice1", systemImage: "1.circle")
                                Label("IOSHomeTab.Text2Speech.Notice2", systemImage: "2.circle")
                                Label("IOSHomeTab.Text2Speech.Notice3", systemImage: "3.circle")
                                Label("IOSHomeTab.Text2Speech.Notice4", systemImage: "4.circle")
                                Label("IOSHomeTab.Text2Speech.Notice5", systemImage: "5.circle")
                                Label("IOSHomeTab.Text2Speech.Notice6", systemImage: "6.circle")
                                Label("IOSHomeTab.Text2Speech.Notice7", systemImage: "7.circle")
                        }

                        Section {
                                Text("IOSHomeTab.FAQ.Question.RestartKeyboard").font(.headline)
                                Text("IOSHomeTab.FAQ.Answer.RestartKeyboard")
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.FAQ")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
