#if os(iOS)

import SwiftUI

struct EnablingKeyboardView: View {

        private let closeApp: String = "https://support.apple.com/zh-hk/HT201330"
        private let restartDevice: String = "https://support.apple.com/zh-hk/HT201559"

        var body: some View {
                List {
                        Section {
                                Text("Jyutping Keyboard not showing up in Settings app?").font(.significant)
                                Text("You may need to close the Settings app, then try again.")
                                SafariLink(closeApp) {
                                        HStack {
                                                Text("How to close an app?")
                                                Spacer()
                                                Image(systemName: "safari").foregroundStyle(Color.secondary)
                                        }
                                }
                        }
                        Section {
                                Text("Jyutping Keyboard not showing up in some other apps?").font(.significant)
                                Text("This is a system bug, you may need to restart this device.")
                                SafariLink(restartDevice) {
                                        HStack {
                                                Text("How to restart device?")
                                                Spacer()
                                                Image(systemName: "safari").foregroundStyle(Color.secondary)
                                        }
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("title.enabling_keyboard")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
