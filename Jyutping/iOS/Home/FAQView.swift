#if os(iOS)

import SwiftUI

struct FAQView: View {
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.FAQ.Question.ExternalKeyboards").font(.significant)
                                Text("IOSHomeTab.FAQ.Answer.ExternalKeyboards")
                        }
                        Section {
                                Text("IOSHomeTab.FAQ.Question.FullAccess").font(.significant)
                                if Device.isPad {
                                        Text("IOSHomeTab.FAQ.Answer.FullAccess.Row2.Clipboard")
                                } else {
                                        HStack {
                                                Text(verbatim: "1.").font(.system(size: 15, design: .monospaced))
                                                Text("IOSHomeTab.FAQ.Answer.FullAccess.Row1.Haptic")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "2.").font(.system(size: 15, design: .monospaced))
                                                Text("IOSHomeTab.FAQ.Answer.FullAccess.Row2.Clipboard")
                                                Spacer()
                                        }
                                }
                        } footer: {
                                Text("IOSHomeTab.FAQ.Footer.FullAccess").textCase(nil)
                        }

                        Section {
                                Text("IOSHomeTab.FAQ.Question.TTS").font(.significant)
                                HStack {
                                        Text.dotMark
                                        Text("IOSHomeTab.Text2Speech.Notice0")
                                        Spacer()
                                }
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
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.FAQ")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
