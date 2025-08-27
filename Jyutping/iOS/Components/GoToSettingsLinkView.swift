#if os(iOS)

import SwiftUI

struct GoToSettingsLinkView: View {
        var body: some View {
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                        HStack(spacing: 12) {
                                Spacer()
                                Image.settings
                                Text("IOSShared.ButtonTitle.GoToSettings")
                                Image.settings.hidden()
                                Spacer()
                        }
                }
        }
}

#endif
