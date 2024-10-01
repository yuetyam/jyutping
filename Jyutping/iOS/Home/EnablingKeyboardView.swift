#if os(iOS)

import SwiftUI

struct EnablingKeyboardView: View {

        private let closeApp: String = "https://support.apple.com/zh-hk/109359"
        private let restartDevice: String = "https://support.apple.com/zh-hk/118259"

        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.EnablingKeyboardView.Question.KeyboardNotFound").font(.significant)
                                Text("IOSHomeTab.EnablingKeyboardView.Answer.KeyboardNotFound")
                                SafariLink(closeApp) {
                                        HStack {
                                                Text("IOSHomeTab.EnablingKeyboardView.Guide.CloseApp")
                                                Spacer()
                                                Image(systemName: "safari").foregroundStyle(Color.secondary)
                                        }
                                }
                        }
                        Section {
                                Text("IOSHomeTab.EnablingKeyboardView.Question.KeyboardUnavailable").font(.significant)
                                Text("IOSHomeTab.EnablingKeyboardView.Answer.KeyboardUnavailable")
                                SafariLink(restartDevice) {
                                        HStack {
                                                Text("IOSHomeTab.EnablingKeyboardView.Guide.RestartDevice")
                                                Spacer()
                                                Image(systemName: "safari").foregroundStyle(Color.secondary)
                                        }
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.EnableKeyboard")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
