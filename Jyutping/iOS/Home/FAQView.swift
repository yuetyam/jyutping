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
                                                Text(verbatim: "1.").font(.subheadline.monospacedDigit())
                                                Text("IOSHomeTab.FAQ.Answer.FullAccess.Row1.Haptic")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "2.").font(.subheadline.monospacedDigit())
                                                Text("IOSHomeTab.FAQ.Answer.FullAccess.Row2.Clipboard")
                                                Spacer()
                                        }
                                }
                        }

                        Section {
                                Text("IOSHomeTab.FAQ.Question.TTS").font(.headline)
                                HStack {
                                        Text.dotMark
                                        Text("IOSHomeTab.Text2Speech.Notice1")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("IOSHomeTab.Text2Speech.Notice2")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("IOSHomeTab.Text2Speech.Notice3")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("IOSHomeTab.Text2Speech.Notice4")
                                        Spacer()
                                }
                                HStack {
                                        Text.dotMark
                                        Text("IOSHomeTab.Text2Speech.Notice5")
                                        Spacer()
                                }
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
