#if os(iOS)

import SwiftUI

struct GoToSettingsLinkView: View {
        var body: some View {
                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                        HStack {
                                Spacer()
                                Text("IOSShared.ButtonTitle.GoToSettings")
                                Spacer()
                        }
                }
        }
}

#endif
